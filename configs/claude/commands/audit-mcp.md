---
description: Security audit for MCP server repositories - check if safe to use and provide credentials
---

## User Input

```text
$ARGUMENTS
```

## Overview

Perform a security audit of an MCP (Model Context Protocol) server repository to determine if it's safe to use and whether it's appropriate to provide sensitive credentials (API keys, tokens, etc.).

## Audit Checklist

### 1. Repository Legitimacy

- [ ] Check repository owner/organization reputation
- [ ] Look for signs of active maintenance (recent commits, issues addressed)
- [ ] Verify it's not a fork with malicious modifications
- [ ] Check star count and community adoption

### 2. Dependency Analysis

- [ ] Review dependencies for known vulnerabilities
- [ ] Check for suspicious or unnecessary dependencies
- [ ] Look for dependency injection risks
- [ ] Verify dependencies are from trusted sources

### 3. Credential Handling

Examine how the MCP server handles credentials:

- [ ] Credentials read from environment variables (GOOD) vs hardcoded (BAD)
- [ ] No credentials logged or printed to stdout/stderr
- [ ] No credentials sent to external services besides the intended API
- [ ] No credential storage in files, databases, or external locations

### 4. Network Activity

Search for suspicious network patterns:

- [ ] Identify ALL outbound network calls
- [ ] Verify network calls only go to expected/documented endpoints
- [ ] Check for data exfiltration patterns (sending data to unknown hosts)
- [ ] Look for telemetry/analytics that might leak sensitive data

### 5. File System Access

- [ ] Check what files/directories the server reads
- [ ] Check what files/directories the server writes
- [ ] Look for access to sensitive paths (~/.ssh, ~/.aws, browser profiles, etc.)
- [ ] Verify no unexpected file operations

### 6. Code Quality & Red Flags

Look for suspicious patterns:

- [ ] Obfuscated or minified source code
- [ ] Base64 encoded strings that decode to URLs or code
- [ ] Dynamic code execution (eval, exec, Function constructor)
- [ ] Shell command execution with user input
- [ ] Cryptocurrency wallet address patterns
- [ ] Encoded/encrypted payloads

### 7. Tool Permissions Analysis

Review what MCP tools are exposed:

- [ ] List all tools and their capabilities
- [ ] Identify tools that could be abused
- [ ] Check if tool permissions follow least-privilege principle
- [ ] Verify tool descriptions match actual functionality

## Output Format

Provide a structured security report:

```markdown
# MCP Security Audit Report

## Summary
- **Repository**: [name/url]
- **Risk Level**: [LOW / MEDIUM / HIGH / CRITICAL]
- **Safe to Use**: [YES / NO / CONDITIONAL]
- **Safe for Credentials**: [YES / NO / WITH CAUTION]

## Findings

### ✅ Passed Checks
- [List of passed security checks]

### ⚠️ Warnings
- [List of concerns that aren't critical]

### ❌ Failed Checks
- [List of security issues found]

## Credential Safety

[Detailed analysis of how credentials are handled]

## Network Analysis

[List of all outbound connections and their purposes]

## Recommendations

[Specific recommendations for safe usage]

## Files Reviewed

[List of key files examined during audit]
```

## Workflow

1. **Locate source files** - Find main entry point and core modules
2. **Map network calls** - Search for HTTP clients, fetch, axios, net modules
3. **Trace credential flow** - Follow environment variables through the code
4. **Review tool implementations** - Check what each MCP tool actually does
5. **Check for red flags** - Search for suspicious patterns
6. **Generate report** - Compile findings into structured report

## Search Patterns

Use these patterns to find potential issues:

```bash
# Network calls
grep -r "http://" --include="*.{js,ts,go,py}"
grep -r "https://" --include="*.{js,ts,go,py}"
grep -r "fetch\|axios\|request\|http.get\|net.dial" --include="*.{js,ts,go,py}"

# Credential handling
grep -r "password\|secret\|token\|api.key\|apikey" --include="*.{js,ts,go,py}"
grep -r "console.log\|print\|fmt.Print" --include="*.{js,ts,go,py}"

# File system
grep -r "readFile\|writeFile\|os.Open\|os.Create" --include="*.{js,ts,go,py}"
grep -r "\.ssh\|\.aws\|\.env\|credentials" --include="*.{js,ts,go,py}"

# Code execution
grep -r "eval\|exec\|Function\(" --include="*.{js,ts,go,py}"
grep -r "child_process\|subprocess\|os.exec" --include="*.{js,ts,go,py}"

# Suspicious patterns
grep -r "base64\|atob\|btoa" --include="*.{js,ts,go,py}"
grep -r "crypto.subtle\|cipher" --include="*.{js,ts,go,py}"
```

## Risk Level Criteria

- **LOW**: Well-maintained, minimal permissions, credentials properly isolated
- **MEDIUM**: Some concerns but no critical issues, popular/trusted source
- **HIGH**: Multiple security concerns, unclear credential handling
- **CRITICAL**: Evidence of malicious code, data exfiltration, or credential theft
