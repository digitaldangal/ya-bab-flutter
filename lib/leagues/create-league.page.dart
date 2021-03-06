import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:yabab/leagues/league.model.dart';
import 'package:yabab/leagues/league.page.dart';
import 'package:yabab/leagues/league.service.dart';

class CreateLeagueWidget extends StatefulWidget {
  final League league;

  CreateLeagueWidget(this.league);

  @override
  _LeagueFormWidgetState createState() => new _LeagueFormWidgetState(league);
}

class LeagueForm {
  String id;
  String name = '';
  String location = '';
}

class _LeagueFormWidgetState extends State<CreateLeagueWidget> {
  League league;

  _LeagueFormWidgetState(League league) {
    if (league != null) {
      _leagueForm.name = league.name;
      _leagueForm.location = league.location;
      _leagueForm.id = league.id;
    }
  }

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final _leagueForm = new LeagueForm();

  void _submit(BuildContext context) {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      League league = new League(
          name: _leagueForm.name,
          id: _leagueForm.id,
          location: _leagueForm.location);

      if (league.id != null) {
        LeagueService.instance
            .update(league)
            .then((value) => LeagueService.instance.findOne(_leagueForm.id))
            .then((league) => _navigateToLeague(league));
      } else {
        LeagueService.instance
            .create(league)
            .then((document) =>
                LeagueService.instance.findOne(document.documentID))
            .then((league) => _navigateToLeague(league));
      }
    }
  }

  void _navigateToLeague(League league) {
    Navigator
        .of(context).pop();
    Navigator
        .of(context)
        .push(new MaterialPageRoute<Null>(builder: (BuildContext context) {
      return new LeagueWidget(league);
    }));
  }

//  void _performLogin(BuildContext context) {
//    // This is just a demo, so no actual login here.
//    final snackbar = new SnackBar(
//      content: new Text('Email: $_name, password: $_location'),
//    );
//
//    scaffoldKey.currentState.showSnackBar(snackbar);
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Create new League'),
      ),
      body: new Form(
        key: formKey,
        child: new Column(
          children: <Widget>[
            new ListTile(
              leading: const Icon(CommunityMaterialIcons.trophy),
              title: new TextFormField(
                initialValue: _leagueForm.name,
                validator: (val) =>
                    val.isEmpty ? 'Name can\'t be empty.' : null,
                onSaved: (val) => _leagueForm.name = val,
                decoration: new InputDecoration(
                  hintText: "Name",
                ),
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.place),
              title: new TextFormField(
                initialValue: _leagueForm.location,
                onSaved: (val) => _leagueForm.location = val,
                decoration: new InputDecoration(
                  hintText: "Location",
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Save',
        child: new Icon(Icons.check),
        onPressed: () {
          _submit(context);
        },
      ),
    );
  }
}
