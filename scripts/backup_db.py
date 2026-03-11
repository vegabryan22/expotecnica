#!/usr/bin/env python3
from __future__ import annotations

import sys
from datetime import date, datetime, time
from decimal import Decimal
from pathlib import Path

from sqlalchemy import text

PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from app import create_app
from app.extensions import db


def escape_string(value: str) -> str:
    escaped = value.replace('\\', '\\\\').replace("'", "\\'")
    escaped = escaped.replace('\n', '\\n').replace('\r', '\\r').replace('\t', '\\t')
    return f"'{escaped}'"


def to_sql_literal(value):
    if value is None:
        return 'NULL'
    if isinstance(value, bool):
        return '1' if value else '0'
    if isinstance(value, (int, float, Decimal)):
        return str(value)
    if isinstance(value, bytes):
        return "X'" + value.hex() + "'"
    if isinstance(value, (datetime, date, time)):
        return escape_string(value.isoformat(sep=' '))
    return escape_string(str(value))


def write_mysql_dump(output_path: Path) -> None:
    app = create_app()
    with app.app_context():
        engine = db.engine
        timestamp = datetime.now().isoformat(sep=' ', timespec='seconds')
        with engine.connect() as conn:
            result = conn.execute(text("SHOW FULL TABLES WHERE Table_type = 'BASE TABLE'"))
            table_names = [row[0] for row in result.fetchall()]

            lines = []
            lines.append('-- Backup generado automaticamente por scripts/backup_db.py')
            lines.append(f'-- Fecha: {timestamp}')
            lines.append('SET FOREIGN_KEY_CHECKS=0;')
            lines.append('')

            for table in table_names:
                create_row = conn.execute(text(f"SHOW CREATE TABLE `{table}`")).fetchone()
                create_sql = create_row[1]
                lines.append(f'DROP TABLE IF EXISTS `{table}`;')
                lines.append(f'{create_sql};')

                rows = conn.execute(text(f"SELECT * FROM `{table}`")).mappings().all()
                if rows:
                    columns = list(rows[0].keys())
                    col_sql = ', '.join(f'`{column}`' for column in columns)
                    for row in rows:
                        values = ', '.join(to_sql_literal(row[column]) for column in columns)
                        lines.append(f'INSERT INTO `{table}` ({col_sql}) VALUES ({values});')
                lines.append('')

            lines.append('SET FOREIGN_KEY_CHECKS=1;')

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text('\n'.join(lines) + '\n', encoding='utf-8')


def main() -> int:
    output_path = Path('sql/backups/expotecnica_latest.sql')
    write_mysql_dump(output_path)
    print(f'Backup generado: {output_path}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
