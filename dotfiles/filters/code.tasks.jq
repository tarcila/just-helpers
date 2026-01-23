# Generate VS Code tasks.json from Justfile json dump
{
  "version": "2.0.0",
  "tasks": [
    .recipes
    | to_entries[]
    | select(
        .value.attributes[]?.metadata?
        | select(. != null)
        | flatten
        | any(. == "task")
      )
  | . as $recipe
  | # Collect all metadata into a single flat array
    [$recipe.value.attributes[]?.metadata? | select(. != null) | flatten] | flatten | unique as $all_metadata
  | 
    {
    "label": $recipe.value.name,
    "type": "process",
    "command": "just",
    "problemMatcher": [ $all_metadata[]? | select(. | startswith("pm=")) | ltrimstr("pm=") ],
    "group": {
      "kind": "build",
      "isDefault": ($all_metadata | index("default") != null),
    },
    "args": [
      $recipe.key
    ],
    "presentation": {
      "reveal": "always",
      "panel": "dedicated",
      "clear": true
    }
  }
  ]
}