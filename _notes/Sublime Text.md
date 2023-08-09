---
title: Sublime Tips
---



[Pep8 Error codes, use to set ignore in SublimeLinter-flake8](https://pep8.readthedocs.io/en/latest/intro.html#error-codes)

### [Debugging Breakpoints](https://codefellows.github.io/sea-python-401d7/readings/sublime_as_ide.html#follow-along "Permalink to this headline")

The final requirement for a reasonable IDE experience is to be able to follow a debugging session in the file where the code exists.

There is no plugin for SublimeText that supports this. But there is a Python package you can install into the virtualenv for each of your projects that does it.

The package is called [PDBSublimeTextSupport](https://pypi.python.org/pypi/PdbSublimeTextSupport) and its simple to install with `pip`:

```bash
(projectenv)$ pip install PDBSublimeTextSupport
```

Once the plugin is installed you have one more step to take. You must configure the Python debugger to communicate with your editor. Add a file called `.pdbrc` to your home directory. In that file, type the following Python code:

```python
from PdbSublimeTextSupport import preloop, precmd
pdb.Pdb.preloop = preloop
pdb.Pdb.precmd = precmd
```

You can also place a `.pdbrc` file in your project where you interact with the command line. Python will read the one from your home directory first, if present. If there is one in your current working directory, that will override the one in your home directory.

Now, whenever you set a breakpoint in your code and it is hit, your editor will open. You’ll see your cursor on the line of code where your debugger is. As you step through the code, you will see the current line in your Sublime Text file move along with you. It will even follow you to other files if you step into functions that are called.