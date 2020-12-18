import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:terminal_launcher/data/styles.dart';

class TerminalPage extends StatefulWidget {
  @override
  _TerminalPageState createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  List names;
  Map package = {};

  final _inputFocus = FocusNode();
  final _inputController = TextEditingController();

  final List<String> _prevResults = [];

  @override
  void initState() {
    super.initState();

    LauncherAssist.getAllApps().then((res) {
      names = res
          .map((app) => app['label'].toLowerCase().replaceAll(' ', ''))
          .toList()
            ..sort();
      // List of map with keys 'package', 'icon', 'label'
      res.forEach((app) =>
          package[app['label'].toLowerCase().replaceAll(' ', '')] =
              app['package']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => Future(() => false),
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              _inputFocus.requestFocus();
              SystemChannels.textInput.invokeMethod('TextInput.show');
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPrevious(),
                    _buildPromt(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildPrevious() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          _prevResults.map((e) => Text(e, style: Styles.inputStyle)).toList(),
    );
  }

  _buildPromt() {
    return Row(
      children: <Widget>[
        Text('~\$ ', style: Styles.terminalPrompt),
        Expanded(
          child: TextField(
            controller: _inputController,
            focusNode: _inputFocus,
            autocorrect: false,
            autofocus: true,
            style: Styles.inputStyle,
            cursorWidth: 6,
            cursorColor: Colors.green,
            decoration: Styles.inputDecor,
            onSubmitted: _submitCommand,
          ),
        ),
      ],
    );
  }

  _submitCommand(String command) {
    command = command.trim();
    if (command == 'help') {
      setState(() => _prevResults.add(
          '~\$ ' + command + '\n' + 'Commands available:\n\tclear\n\thelp\n\tls\n'));
    } else if (command == 'clear') {
      setState(() => _prevResults.clear());
    } else if (command == 'ls') {
      setState(
          () => _prevResults.add('~\$ ' + command + '\n' + names.join('\n')));
    } else if (names.contains(command)) {
      LauncherAssist.launchApp(package[command]);
      setState(() =>
          _prevResults.add('~\$ ' + command + '\n' + 'Launching $command...'));
    } else {
      setState(() => _prevResults.add('~\$ ' + command + '\nInvalid command'));
    }
    _inputController.text = '';
  }
}
