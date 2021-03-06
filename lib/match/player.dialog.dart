import 'package:flutter/material.dart';
import 'package:yabab/match/match.model.dart';
import 'package:yabab/users/user.model.dart';
import 'package:yabab/users/user.service.dart';
import 'package:yabab/users/user.tile.dart';

enum PlayerDialogAction {
  cancel,
  discard,
  save,
}

class PlayerDialog extends StatefulWidget {
  final MatchMaking match;

  PlayerDialog(this.match);

  @override
  PlayerDialogState createState() => new PlayerDialogState(this.match);
}

class PlayerDialogState extends State<PlayerDialog> {
  final MatchMaking match;

  PlayerDialogState(this.match);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: const Text('Player Selector'), actions: <Widget>[]),
        body: new UserList(this.match));
  }
}

class UserList extends StatelessWidget {
  final MatchMaking match;

  UserList(this.match);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: UserService.instance.findAllUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.where((user) {
            return !this.match.isPlaying(user.id);
          }).map((user) {
            return new UserListTile(user, () => _selectUser(user, context));
          }).toList(),
        );
      },
    );
  }
}

void _selectUser(User user, BuildContext context) {
  Navigator.pop(context, user);
}
