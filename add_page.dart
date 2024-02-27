import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  final Map? todo;
  const AddPage({super.key,this.todo});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final todo = widget.todo;
    if(todo!=null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(isEdit?'Edit Todo':'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description'
            ),
            maxLines: 8,
            minLines: 3,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: (){
                isEdit?updateData():submitData();
              },
              child:  Text(isEdit?'Update':'Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> submitData() async{
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      'title':title,
      'description':description,
    };
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,body: jsonEncode(body),headers: {'Content-Type': 'application/json'});
    if(response.statusCode==201){
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage('Creation Success');
    }
    else{
      showErrorMessage('Creation Failure');
    }
  }
  Future<void> updateData() async{
    final todo = widget.todo;
    if(todo==null){
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      'title': title,
      'description':description,

    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,body: jsonEncode(body),headers: {'Content-Type': 'application/json'});
    if(response.statusCode==200){
      showSuccessMessage('Updation SuccessFully');
    }
    else{
      showErrorMessage('Updation Failed');
    }

  }

  // Future<void> submitData() async{
  //   final title = titleController.text;
  //   final description = descriptionController.text;
  //   final body = {
  //     'title':title,
  //     'description':description,
  //     'is_completed':false,
  //   };
  //   final Url = 'https://api.nstack.in/v1/todos';
  //   final uri =  Uri.parse(Url);
  //   final response = await http.post(
  //     uri,
  //     body: jsonEncode(body),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //   if(response.statusCode==201){
  //     titleController.text = '';
  //     descriptionController.text = '';
  //     showSuccessMessage('Creation Success');
  //   }
  //   else{
  //     showErrorMessage('Creation Failed');
  //   }
  // }
  // Future<void> updateData() async{
  //   final todo = widget.todo;
  //   if(todo == null){
  //     print('You can not call updated without todo data');
  //     return;
  //   }
  //   final id = todo['_id'];
  //   final title = titleController.text;
  //   final description = descriptionController.text;
  //   final body = {
  //     'title':title,
  //     'description':description,
  //     'is_completed':false,
  //   };
  //   final url = 'https://api.nstack.in/v1/todos/$id';
  //   final uri = Uri.parse(url);
  //   final response = await http.put(uri,body: jsonEncode(body),headers:{'Content-Type': 'application/json'});
  //    if(response.statusCode==200){
  //      showSuccessMessage('Updation Successfully');
  //    }
  //    else{
  //      showErrorMessage('Updation Failed');
  //    }
  // }
  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showErrorMessage(String message){
    final snackBar = SnackBar(content: Text(message,style: TextStyle(color: Colors.white,backgroundColor: Colors.red),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


