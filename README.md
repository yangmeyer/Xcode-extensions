Xcode-extensions
================

Xcode lacks some neat features I know from other IDEs, so I read up on text macros, user scripting and `sed`, and wrote up some useful little helpers to extend Xcode with the features I missed.

Scripts
-------

*	**insert-super-call.sh** — Inserts a call to the current method’s `super` implementation.

Integration
-----------

1.	Xcode: Menu with the scroll (User scripts) -> Edit User Scripts…
2.	Plus icon -> Add Script File…
3.	Locate and choose the script file.
4.	Set the input/output types as specified in the script header.
5.	Optionally, assign a keyboard shortcut.