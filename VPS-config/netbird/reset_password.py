import sqlite3
import bcrypt
import shutil
import os
from datetime import datetime

# — USER CONFIGURATION —

TARGET_USERNAME = "admin"            # The value to search for in username or email
NEW_PLAINTEXT_PASSWORD = "NEW_PASSWORD"
DB_PATH = "/var/lib/docker/volumes/netbird_netbird_data/_data/idp.db"  # Path to the file inside the volume
BACKUP_DIR = "/root/netbird/backups"

def generate_hash(password: str):
    """Generates a bcrypt hash with a cost factor of 10."""
    password_bytes = password.encode('utf-8')
    salt = bcrypt.gensalt(rounds=10)
    hash_bytes = bcrypt.hashpw(password_bytes, salt)
    return hash_bytes.decode('utf-8')

def create_backup(source_path):
    """Creates a timestamped backup of the database file."""
    if not os.path.exists(BACKUP_DIR):
        os.makedirs(BACKUP_DIR)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = os.path.join(BACKUP_DIR, f"idp_backup_{timestamp}.db")

    try:
        shutil.copy2(source_path, backup_path)
        print(f"Backup created: {backup_path}")
        return True
    except Exception as e:
        print(f"Backup failed: {e}")
        return False

def update_db():
    """Uses TARGET_USERNAME and NEW_PLAINTEXT_PASSWORD to update the DB."""
    # 1. Generate the hash first
    new_hash = generate_hash(NEW_PLAINTEXT_PASSWORD)

    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()

        # 2. Execute query using the global variables
        query = "UPDATE password SET hash = ? WHERE username = ? OR email = ?"
        cursor.execute(query, (new_hash, TARGET_USERNAME, TARGET_USERNAME))

        if cursor.rowcount == 0:
            print(f"No user found matching: {TARGET_USERNAME}")
        else:
            conn.commit()
            print(f"Success: Hash updated for '{TARGET_USERNAME}'")

    except sqlite3.Error as e:
        print(f"SQLite error: {e}")
    finally:
        if 'conn' in locals():
            conn.close()
if __name__ == "__main__":
    if not os.path.exists(DB_PATH):
        print(f"Error: Database not found at {DB_PATH}")
    else:
        if create_backup(DB_PATH):
            update_db()