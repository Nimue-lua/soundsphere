# Lua Code Style Guide

This guide defines the Lua coding conventions for the Rizu project, specifically targeting the patterns found in the `rizu/` subfolder.

## 1. Naming Conventions

### 1.1 Modules and Classes
- **Format:** `PascalCase`
- **Example:** `RhythmEngine`, `AudioEngine`, `InputBinder`
- **Description:** All files that return a class or module should use `PascalCase` for both the filename and the local variable representing the class.

### 1.2 Methods
- **Format:** `camelCase`
- **Example:** `setTime()`, `loadAudio()`, `getStartTime()`
- **Description:** Functions defined on classes or modules should use `camelCase`.

### 1.3 Variables and Properties
- **Format:** `snake_case`
- **Example:** `logic_info`, `logic_offset`, `self.chart_audio`
- **Description:** Local variables and object properties should use `snake_case`.

### 1.4 Local Variables for Modules
- **Format:** `PascalCase`
- **Example:** `local RhythmEngine = class()`, `local InputEngine = require(...)`
- **Description:** When requiring a module that follows the project's class pattern, the local variable should match the class name in `PascalCase`.

### 1.5 Arguments
- **Format:** Mixed (`snake_case` or `camelCase`)
- **Example:** `function MyClass:new(replayBase, computeContext, config, resources)`
- **Description:** Simple arguments often use `snake_case` (e.g., `rate`, `time`). Complex objects passed as arguments (especially those originating from the legacy `sphere` modules) often use `camelCase`. When in doubt, prefer `snake_case` for new code unless matching an existing external interface.

## 2. Formatting

### 2.1 Indentation
- **Style:** Tabs
- **Description:** Use a single tab character per indentation level.

### 2.2 Spacing
- Use a single space around binary operators (`=`, `+`, `-`, `*`, `/`, `==`, `~=`, etc.).
- No space between function name and opening parenthesis.
- No space inside parentheses or braces unless for clarity in complex expressions.

### 2.3 Documentation (EmmyLua)
- Use `---` for EmmyLua annotations.
- Every class should have a `---@class` annotation.
- Public methods should have `---@param` and `---@return` annotations.

## 3. Structure

### 3.1 Class Pattern
The project uses a custom `class()` helper for object orientation.

```lua
local class = require("class")

---@class MyModule
---@operator call: MyModule
local MyModule = class()

function MyModule:new()
	self.some_property = 0
end

function MyModule:myMethod()
	-- logic here
end

return MyModule
```

### 3.2 Module Resolution
- Use dot notation for `require` statements.
- Root packages include `rizu`, `aqua`, `ncdk`, `sea`, `sphere`.
- **Example:** `require("rizu.engine.audio.AudioEngine")`
