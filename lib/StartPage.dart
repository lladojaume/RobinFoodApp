import 'package:flutter/material.dart';
import 'package:uceda/mapa.dart';

class StartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StartPageState();
  }
}

class _StartPageState extends State<StartPage> {
  var _tipus = ['Japones', 'Mexica', 'FastFood', 'TakeAway', 'Pizzeria'];
  var _currentTipusSelected = 'Japones';
  int _currentPreuSelected = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Robin Food"),
        backgroundColor: Colors.red[900],
      ),
      body: Container(
        margin: EdgeInsets.all(100.0),
        child: Column(
          children: <Widget>[
            Text(
              'TIPUS',
              style: TextStyle(fontSize: 20),
            ),
            DropdownButton<String>(
              itemHeight: 100,
              items: _tipus.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(
                    dropDownStringItem,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
              onChanged: (String newValueSelected) {
                _onDropDownItemSelected(newValueSelected);
              },
              value: _currentTipusSelected,
            ),
            SizedBox(height: 80),
            Text('PREU MÀXIM MENU ', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(
              _currentPreuSelected.toString() + '€',
              style: TextStyle(fontSize: 20),
            ),
            Slider(
              value: (_currentPreuSelected ?? 100).toDouble(),
              min: 0,
              max: 50,
              divisions: 50,
              activeColor: Colors.red[900],
              onChanged: (val) =>
                  setState(() => _currentPreuSelected = val.round()),
            ),
            SizedBox(height: 80),
            RaisedButton(
                color: Colors.red[900],
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: const Text('Buscar restaurants',
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                ),
                onPressed: () {
                  print(_currentTipusSelected +
                      ' ' +
                      _currentPreuSelected.toString() +
                      '€');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Mapa(
                              _currentTipusSelected, _currentPreuSelected)));
                }),
          ],
        ),
      ),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentTipusSelected = newValueSelected;
    });
  }
}
