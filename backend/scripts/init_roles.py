# scripts/init_roles.py
import sys
from pathlib import Path

# Add project root to path
sys.path.append(str(Path(__file__).parent.parent))

from backend.app.db.postgres import SessionLocal
from backend.app.services.role_service import initialize_default_roles

def main():
    db = SessionLocal()
    try:
        created = initialize_default_roles(db)
        if created:
            print(f"✅ Created roles: {', '.join(created)}")
        else:
            print("✅ All default roles already exist")
    except Exception as e:
        print(f"❌ Error initializing roles: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    main()