mod code './code.just'

[doc("This is the first recipe")]
[metadata("task", "code", "default")]
[metadata("pm=$gcc")]
task1:
    echo "This is task 1"

[doc("This is the second recipe")]
[metadata("launch", "code")]
[metadata("debug", "debug:native")]
[metadata("args=-v -e -gltf /data/gltf/glTF-Sample-Assets-main/Models/CompareIridescence/glTF/CompareIridescence.gltf -hdri /data/Envmaps/glTF-Sample-Environments-main/papermill.hdr")]
task2:
    echo "This is task 2"

[doc("This is the third recipe")]
[metadata("task", "code")]
task3:
    echo "This is task 3"

[doc("Generates visual studio tasks file")]
[metadata("task", "code")]
generate_vscode_tasks_json: (code::generate_vscode_tasks_json ".vscode")

[doc("Generates visual studio launch file")]
[metadata("task", "code")]
generate_vscode_launch_json: (code::generate_vscode_launch_json ".vscode")
