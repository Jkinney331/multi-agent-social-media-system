# Contributing to Multi-Agent Social Media Management System

We love your input! We want to make contributing to the Multi-Agent Social Media Management System as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Development Process

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

## Pull Requests

Pull requests are the best way to propose changes to the codebase. We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## Any contributions you make will be under the MIT Software License

In short, when you submit code changes, your submissions are understood to be under the same [MIT License](http://choosealicense.com/licenses/mit/) that covers the project. Feel free to contact the maintainers if that's a concern.

## Report bugs using GitHub's [issue tracker](https://github.com/Jkinney331/multi-agent-social-media-system/issues)

We use GitHub issues to track public bugs. Report a bug by [opening a new issue](https://github.com/Jkinney331/multi-agent-social-media-system/issues/new).

## Write bug reports with detail, background, and sample code

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

## Feature Requests

We welcome feature requests! Please:

1. Check if the feature has already been requested
2. Provide a clear and detailed explanation of the feature
3. Explain why this feature would be useful
4. Consider providing a basic implementation plan

## Development Setup

### Prerequisites

- **n8n** (latest version)
- **PostgreSQL** 13+
- **Node.js** 18+
- **Slack workspace** with bot permissions
- **API Keys**: OpenAI, HeyGen, ElevenLabs, Composio

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/Jkinney331/multi-agent-social-media-system.git
   cd multi-agent-social-media-system
   ```

2. **Set up the database**
   ```bash
   createdb social_media_agents
   psql social_media_agents < enhanced_database_schema.sql
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys and configuration
   ```

4. **Start n8n and import workflows**
   ```bash
   n8n start
   # Import the 6 core workflows through n8n UI
   ```

5. **Run tests** (when available)
   ```bash
   npm test
   ```

## Coding Conventions

### n8n Workflows
- Use descriptive node names with emojis
- Include comprehensive error handling
- Document complex JavaScript code nodes
- Use consistent variable naming

### Database
- Follow PostgreSQL naming conventions
- Use appropriate indexes for performance
- Include migration scripts for schema changes

### Documentation
- Update README.md for significant changes
- Include inline comments for complex logic
- Provide examples in documentation

## Project Structure

```
├── README.md                          # Main project documentation
├── DEPLOYMENT_GUIDE.md               # Production deployment guide
├── MCP_Integration_Guide.md           # MCP server integration
├── PRD_Multi_Agent_System.md          # Product requirements
├── enhanced_database_schema.sql       # Main database schema
├── database_setup.sql                 # Legacy schema
└── SETUP_GUIDE.md                    # Setup instructions
```

## Workflow Contribution Guidelines

When contributing n8n workflows:

1. **Export workflows** in JSON format
2. **Remove sensitive data** (API keys, tokens)
3. **Document workflow purpose** and dependencies
4. **Include example data** for testing
5. **Test thoroughly** before submitting

## Code Style

- Use **ESLint** for JavaScript/TypeScript
- Follow **PostgreSQL** naming conventions for database
- Use **meaningful commit messages**
- Include **emoji in commit messages** for clarity

### Commit Message Examples

```
🐛 Fix: Resolve Slack authentication timeout
✨ Feature: Add Instagram Story publishing
📚 Docs: Update MCP integration guide
🔧 Config: Add rate limiting for Composio API
```

## Testing

- **Integration tests** for workflows
- **Database tests** for schema changes
- **API tests** for external integrations
- **Performance tests** for high-load scenarios

## Community

- **Discussions**: Use GitHub Discussions for questions
- **Issues**: Report bugs and request features
- **Discord**: Join our community server (coming soon)

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation

## Questions?

Feel free to reach out by:
- Opening a GitHub issue
- Starting a GitHub discussion
- Contacting maintainers directly

Thank you for contributing to making social media management better for development agencies worldwide! 🚀 