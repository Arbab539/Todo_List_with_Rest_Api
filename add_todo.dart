
import 'dart:convert';

import 'package:dummy/add_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoList extends StatefulWidget {
  const AddTodoList({super.key});

  @override
  State<AddTodoList> createState() => _AddTodoListState();
}

class _AddTodoListState extends State<AddTodoList> {

  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    fetchTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            addPage();
          },
          label: const Text('Add Todo')
      ),
      body: Visibility(
        visible: items.isNotEmpty,
        replacement: Center(child: Text('No Todo items',style: Theme.of(context).textTheme.headline3,),),
        child: RefreshIndicator(
            onRefresh: fetchTodo,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context,index){
                final item = items[index];
                final id = item['_id'] as String;
                return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index+1}')),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value){
                        if(value == 'edit'){
                          addToEditPage(item);
                        }
                        else if(value == 'delete'){
                          deleteById(id);
                        }
                      },
                      itemBuilder: (context){
                        return [
                          PopupMenuItem(
                              child: Text(
                                  'Edit',),
                            value: 'edit',
                          ),
                          PopupMenuItem(
                              child: Text('Delete'),
                            value: 'delete',
                          ),
                        ];
                      },
                    ),
                    ),
                  );
                })),
      ),
      // body: Visibility(
      //   visible: items.isNotEmpty,
      //   replacement: Center(child: Text('No Todo Item',style: Theme.of(context).textTheme.headline3,),),
      //   child: RefreshIndicator(
      //     onRefresh: fetchTodo,
      //     child: ListView.builder(
      //         itemCount: items.length,
      //         padding: const EdgeInsets.all(8),
      //         itemBuilder: (context,index){
      //           final item = items[index];
      //           final id = item['_id'] as String;
      //           return Card(
      //             child: ListTile(
      //               leading: CircleAvatar(child: Text('${index+1}'),),
      //               title: Text(item['title']),
      //               subtitle: Text(item['description']),
      //               trailing: PopupMenuButton(
      //                 onSelected: (value){
      //                  
      //                 },
      //                 itemBuilder:(context){
      //                   return [
      //                     PopupMenuItem(
      //                         child: Text('Edit')
      //                     ),
      //                     PopupMenuItem(
      //                         child: Text('Delete')
      //                     )
      //                   ];
      //                 },
      //               ),
      //             ),
      //           );
      //         }
      //     ),
      //   ),
      // ),
    );
  }
  Future<void> addPage()async{
    final route = MaterialPageRoute(builder: (context)=>const AddPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }
  Future<void> addToEditPage(Map item) async{
    final route = MaterialPageRoute(builder: (context)=>AddPage(todo: item,));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }



  Future<void> fetchTodo() async{
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      final result = json['items'];

      setState(() {
        items = result;
      });
      setState(() {
        isLoading = false;
      });

    }

  }

  Future<void> deleteById(String id) async{
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri,headers: {'accept': 'application/json'});
    if(response.statusCode == 200){
      final filtered = items.where((element) => element['_id'] !=id).toList();
      setState(() {
        items = filtered;
      });
    }
    else{
      showErrorMessage('Deletion Failed');
    }
  }

  void showErrorMessage(String message){
    final snackBar = SnackBar(content: Text(message,style: TextStyle(color: Colors.white,backgroundColor: Colors.red),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  // Future<void> fetchTodo() async{
  //   final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
  //   final uri = Uri.parse(url);
  //   final response = await http.get(uri);
  //   if(response.statusCode==200){
  //     final json = jsonDecode(response.body);
  //     final result = json['items'];
  //     setState(() {
  //       items = result;
  //     });
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
}

