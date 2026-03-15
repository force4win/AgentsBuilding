# Global Security Guard (Always On)
Description: Protects the workspace from accidental leaks and unauthorized modifications.

## Rules
1. **Secrets Management**: Never print, log, or commit API keys, passwords, or tokens.
2. **PII Protection**: Mask any Personally Identifiable Information (PII) during debugging.
3. **Restricted Files**: Modification of `.env`, `.git`, or sensitive CI/CD configs requires explicit user confirmation.
4. **Environment Isolation**: Always use environment variables instead of hardcoded strings for configuration.
