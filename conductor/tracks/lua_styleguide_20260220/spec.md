# Specification: Lua Code Style Guide

## Overview
The goal of this track is to create a formal Lua code style guide for the project, based on the existing patterns found in the `rizu/` subfolder. This guide will serve as a reference for both human contributors and AI assistants (like Gemini CLI) to ensure consistency across the codebase.

## Functional Requirements
- Analyze the `rizu/` subfolder to identify naming conventions, formatting rules, and structural patterns.
- Focus on extracting and documenting naming conventions (variables, functions, classes, modules).
- Create a single markdown file containing the style guide.
- Save the file to `conductor/code_styleguides/lua.md`.

## Non-Functional Requirements
- The style guide must strictly adhere to the patterns found in the `rizu/` subfolder.
- The guide should be written in a clear, concise format suitable for AI consumption.

## Acceptance Criteria
- [ ] A new file `conductor/code_styleguides/lua.md` exists.
- [ ] The file accurately reflects naming conventions and patterns from the `rizu/` subfolder.
- [ ] The file follows a single-file organization structure.

## Out of Scope
- Major refactoring of existing code to match the new style guide (unless explicitly requested in a separate track).
- Integrating external linting tools like `luacheck` (though the guide may inform their configuration).
