# ───────────────────────────────────────────────────────────
# 📦 Terraform State - Complete Explanation (Comments Only)
# ───────────────────────────────────────────────────────────

# ─── 📘 What is Terraform State? ────────────────────────────
# Terraform state is a file that stores the current status of your infrastructure
# as understood by Terraform. It tracks:
#   - Which resources exist
#   - Their current configuration and metadata (IDs, IPs, etc.)
#   - Dependencies between resources
#   - Outputs and variables

# By default, state is stored locally in 'terraform.tfstate'

# ─── 🔐 Why is State Important? ─────────────────────────────
# 1. Terraform uses it to determine what to change in 'plan' & 'apply'
# 2. Without it, Terraform has no memory of past deployments
# 3. It prevents accidental changes to resources
# 4. Enables import of existing resources

# ─── 🗂️ Local vs Remote State ───────────────────────────────

# 📍 Local State:
# - Stored in terraform.tfstate in current directory
# - Good for learning or testing
# - Not safe for teams or production

# 🌐 Remote State (Recommended):
# - Stored in remote backends like:
#     ▪ AWS S3 (most common)
#     ▪ Terraform Cloud
#     ▪ Consul, etcd
# - Enables:
#     ▪ Shared state access for teams
#     ▪ State locking (avoid two people changing same infra)
#     ▪ Versioning and backup

# ─── 🔧 Remote State Backend Example ─────────────────────────

# Example: Store state in AWS S3 and lock using DynamoDB
# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bucket"
#     key            = "dev/vpc/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }

# Note: You run `terraform init` again after adding or changing backend.

# ─── 📜 Terraform State Commands ────────────────────────────

# ✅ terraform init
#   Initializes Terraform and configures backend (if defined)

# ✅ terraform plan
#   Compares your configuration with the current state

# ✅ terraform apply
#   Makes changes to infrastructure and updates state

# ✅ terraform state list
#   Lists all resources tracked in the current state

# ✅ terraform state show <resource>
#   Shows detailed info from the state for that resource

# ✅ terraform state rm <resource>
#   Removes a resource from the state (not from AWS)

# ✅ terraform state mv <old> <new>
#   Moves/renames a resource in the state

# ✅ terraform import <resource> <real-world-id>
#   Adds existing resource to Terraform state

# ✅ terraform refresh
#   Updates state file with real-world values (IP, tags, etc.)

# ─── 🛑 Do Not: ──────────────────────────────────────────────
# - Never manually edit terraform.tfstate unless you're 100% sure
# - Never push .tfstate to GitHub in real projects (contains secrets sometimes)
# - Always use remote state + locking in team environments

# ─── 🔐 State File Security ─────────────────────────────────
# - Sensitive data like passwords, secrets, access keys may be stored in plain text
# - Use encryption (e.g., S3 bucket with SSE enabled)
# - Always enable locking with DynamoDB when using S3 backend

# ─── 📁 .terraform/ Directory ───────────────────────────────
# - Stores provider binaries and plugin info
# - Auto-created by `terraform init`
# - Contains state backup as well (.backup file)

# ─── 📝 terraform.tfstate.backup ────────────────────────────
# - Automatically created backup before last state change
# - Useful to recover in case of accidental state corruption

# ─── 🔄 terraform.tfstate.d/ ────────────────────────────────
# - Created when using workspaces
# - Each workspace has its own subfolder here

# ─── 🧠 Workspaces & State ──────────────────────────────────
# - Default workspace = "default"
# - Each workspace has its own state
# - Used to manage different environments (e.g., dev, prod)

# ─── ✅ Best Practices Summary ──────────────────────────────
# 1. Use remote state (S3 + DynamoDB) for team collaboration
# 2. Enable versioning on S3 bucket to track state history
# 3. Protect state file — contains sensitive data
# 4. Never manually edit .tfstate file
# 5. Regularly backup state in CI/CD pipelines

# ───────────────────────────────────────────────────────────
# End of Terraform State Explanation
# ───────────────────────────────────────────────────────────
