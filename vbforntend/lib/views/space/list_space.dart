import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/controllers/space_controller.dart';
import 'package:vbforntend/data/response/status.dart';
import 'package:vbforntend/models/space.dart';

class ListSpace extends StatefulWidget {
  const ListSpace({super.key});

  @override
  State<ListSpace> createState() => _ListSpaceState();
}

class _ListSpaceState extends State<ListSpace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spaces"),
      ),
      body: ChangeNotifierProvider<SpaceController>(
        create: (context) => SpaceController()..fetchProfile(context),
        child: Consumer<SpaceController>(builder: (context, value, child) {
          var apiResponse = value.apiResponse;
          if (apiResponse.status == Status.LOADING) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else if (apiResponse.status == Status.COMPLETED) {
            List<Space> space_list = apiResponse.data as List<Space>;

            return ListView.builder(
              itemCount: space_list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(space_list[index].title!),
                );
              },
            );
          } else {
            //dispaly error as you like
            return Container(
              child: Text("error"),
            );
          }
        }),
      ),
    );
  }
}
