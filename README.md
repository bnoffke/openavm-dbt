# Minimal dbt-DuckDB Starter

A minimal dbt project with DuckDB, spatial extension, and SFTP support.

## Quick Start

### 1. Install uv (if not already installed)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. Set up project

```bash
# Install dependencies
uv sync

# Copy profile configuration
mkdir -p ~/.dbt
cp profiles.yml.example ~/.dbt/profiles.yml

# Edit ~/.dbt/profiles.yml if needed (usually the defaults work)
```

### 3. (Optional) Mount SFTP

If using SFTP for data storage:

```bash
# Install sshfs first (if not installed)
# Ubuntu/Debian: sudo apt-get install sshfs
# macOS: brew install macfuse && brew install gromgit/fuse/sshfs-mac

# Mount SFTP
mkdir -p ~/sftp_data
sshfs user@sftp-server:/remote/path ~/sftp_data

# Verify
ls ~/sftp_data
```

### 4. Add your data

Place your data files in one of:
- `./data/raw/` (local files)
- `~/sftp_data/` (if using SFTP mount)

Or update model paths to point to your data location.

### 5. Run dbt

```bash
# Run all models
uv run dbt run

# Check outputs
ls -lh output/parquet/

# Run specific model
uv run dbt run --select stg_example

# Run with tests
uv run dbt test
```

## Project Structure

```
.
├── dbt_project.yml              # Project configuration
├── pyproject.toml               # uv/Python dependencies
├── profiles.yml.example         # Connection configuration
├── models/
│   ├── staging/
│   │   ├── stg_example.sql           # Example staging model
│   │   └── stg_spatial_example.sql   # Spatial extension example
│   └── marts/
│       └── example_output.sql        # Example external parquet output
├── data/
│   ├── my_database.duckdb       # DuckDB database (created on first run)
│   └── raw/                     # Local data files (or use ~/sftp_data/)
└── output/
    └── parquet/                 # External parquet outputs
```

## Key Features

### ✅ uv Environment Management

All dbt commands run with `uv run`:
```bash
uv run dbt run
uv run dbt test
uv run dbt docs generate
```

### ✅ Spatial Extension (Automatic)

Spatial functions work automatically:
```sql
select st_point(lon, lat) as geometry
```

No manual installation needed - it's in `profiles.yml`:
```yaml
extensions:
  - spatial
```

### ✅ SFTP Support

Mount SFTP as local filesystem:
```bash
sshfs user@server:/path ~/sftp_data
```

Then read files normally:
```sql
select * from read_csv_auto('~/sftp_data/file.csv')
```

### ✅ External Parquet Output

Models with `materialized='external'` write parquet files:
```sql
{{ config(
  materialized='external',
  location='./output/parquet/my_output.parquet'
) }}

select * from {{ ref('stg_example') }}
```

## Customization

### Update Data Sources

Edit `models/staging/stg_example.sql`:
```sql
with source as (
    -- Change this to your data location
    select * from read_csv_auto('./data/raw/sales.csv')
),
```

### Add Your Models

Create new files in:
- `models/staging/` for data loading and initial transformations
- `models/marts/` for final outputs

### Configure External Outputs

In `dbt_project.yml`:
```yaml
models:
  my_project:
    marts:
      +materialized: external
      +location: './output/parquet/'  # Change output location
      +format: parquet
```

## Common Commands

```bash
# Run all models
uv run dbt run

# Run specific model
uv run dbt run --select stg_example

# Run models matching pattern
uv run dbt run --select staging.*

# Run tests
uv run dbt test

# Full build (run + test)
uv run dbt build

# Debug connection
uv run dbt debug

# Generate docs
uv run dbt docs generate
uv run dbt docs serve
```

## Troubleshooting

### Spatial Extension Not Working

Check if spatial is in your profile:
```bash
cat ~/.dbt/profiles.yml | grep spatial
# Should see: - spatial
```

Test manually:
```bash
uv run python -c "import duckdb; con = duckdb.connect('data/my_database.duckdb'); con.execute('LOAD spatial'); con.execute('SELECT st_point(0,0)'); print('Spatial works!')"
```

### SFTP Not Mounted

Check mount:
```bash
df -h | grep sftp
```

Remount if needed:
```bash
sshfs user@server:/path ~/sftp_data
```

### External Files Not Created

Ensure output directory exists:
```bash
mkdir -p output/parquet
```

Check configuration in `dbt_project.yml`.

### uv Command Not Found

Install uv:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Restart terminal or source profile:
```bash
source ~/.bashrc  # or ~/.zshrc
```

## Next Steps

1. ✅ Update `models/staging/stg_example.sql` with your data source
2. ✅ Add your column mappings
3. ✅ Create your business logic in staging/marts
4. ✅ Run `uv run dbt run`
5. ✅ Check outputs in `output/parquet/`

## Resources

- [dbt Documentation](https://docs.getdbt.com)
- [dbt-duckdb Plugin](https://github.com/duckdb/dbt-duckdb)
- [DuckDB Spatial Extension](https://duckdb.org/docs/extensions/spatial)
- [uv Documentation](https://github.com/astral-sh/uv)

---

**Questions?** See [SIMPLE_SETUP_GUIDE.md](../SIMPLE_SETUP_GUIDE.md) for detailed explanations.
