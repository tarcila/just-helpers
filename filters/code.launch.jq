# Generate VS Code launch.json from Justfile json dump
# Uses debugger configurations from slurpfile
{
  "version": "0.2.0",
  "configurations": [
    # Extract recipes that have "launch" in their metadata
    .recipes 
    | to_entries[]
    | select(
        .value.attributes[]?.metadata?
        | select(. != null)
        | flatten
        | any(. == "launch")
      )
    | . as $recipe
    | # Collect all metadata into a single flat array
      [$recipe.value.attributes[]?.metadata? | select(. != null) | flatten] | flatten | unique as $all_metadata
    # Generate a single configuration per recipe based on metadata priority
        | ($all_metadata[] | select((. == "debug") or (. | startswith("debug:")))) as $debugtuple
        | (if ($debugtuple | startswith("debug:")) then ($debugtuple | ltrimstr("debug:")) else "default" end) as $debugtype
        | (if ($config[0]["debug"][$debugtype] | type) == "string" then $config[0]["debug"][$debugtype] else $debugtype end) as $debugtype
        | (if ($config[0]["debug"][$debugtype] | type) == "string" then $config[0]["debug"][$debugtype] else $debugtype end) as $debugtype
        | (if ($config[0]["debug"][$debugtype] | type) != "object" then error("Invalid debug configuration '" + $debugtype + "', should be a dict") end)
        | # Use matching debug configuration
          $config[0]["debug"][$debugtype] | . + {
            "name": ($recipe.value.name + (if ($debugtuple == "debug") then "" else " (" + $debugtype + ")" end)),
            "program": $just,
            "args": [$recipe.key],
          }
  ]
}