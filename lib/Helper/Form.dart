import 'package:flutter/material.dart';

class CustomForm extends StatefulWidget {
  Function onSubmit;
  List<Map<String, dynamic>> inputFields = [];

  CustomForm(this.onSubmit, this.inputFields);

  _CustomForm createState() {
    return new _CustomForm();
  }
}

class _CustomForm extends State<CustomForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> inputFields = [];
  Function onSubmit;

  void initState() {
    inputFields = widget.inputFields;
    onSubmit = widget.onSubmit;
    super.initState();
  }

  Widget buildInputFields(item) {
    if (item['title'] == "SubmitButton") {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
        child: RaisedButton(
          color: Colors.blueGrey,
          child: Text(item['buttonTitle']),
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }
            _formKey.currentState.save();
            onSubmit(context);
          },
        ),
      );
    }
    return TextFormField(
      keyboardType: item['type'],
      autofocus: true,
      decoration: InputDecoration(labelText: item['labelText']),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title Is Required';
        }
      },
      onSaved: (String value) {
        setState(() {
          item['value'] = value;
        });
      },
    );
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          child: Column(
        children: inputFields.map((item) {
          return buildInputFields(item);
        }).toList(),
      )),
    );
  }
}

// ListView.builder(
//         itemBuilder: buildInputFields,
//         itemCount: inputFields.length,
//       )
