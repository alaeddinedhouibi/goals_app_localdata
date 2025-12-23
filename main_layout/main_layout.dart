import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goals_app_localdata/main_layout/clubit/main_cubit.dart';
import 'package:goals_app_localdata/main_layout/componemts/goal_item.dart';
import 'package:goals_app_localdata/main_layout/clubit/main_states.dart';
import 'package:goals_app_localdata/main_layout/description_main.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit()..initSQL()..getData(),
      child: BlocConsumer<MainCubit, MainStates>(
        listener: (context, state) {
          if (state is InsertDataSuccessState) {
            print('🎉 Insert successful, clearing controllers');
            var cubit = MainCubit.get(context);
            cubit.addTextController.clear();
            cubit.statusTextController.clear();
          }
        },
        builder: (context, state) {
          final cubit = MainCubit.get(context);
          
          print('🔄 Building UI with ${cubit.goals_list.length} goals, state: $state');
          
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 253, 254, 254),
              leading: const Icon(Icons.grid_goldenratio_sharp),
              title: Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    colors: [
                      const Color.fromARGB(255, 3, 63, 5).withOpacity(0.8),
                      const Color.fromARGB(255, 79, 247, 1).withOpacity(0.3),
                    ],
                  ),
                ),
                child: const Text(
                  'G O A L S',
                  style: TextStyle(
                    letterSpacing: 4,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 2, 1, 65),
                  ),
                ),
              ),
            ),
            body: Container(
              color: const Color.fromARGB(255, 1, 104, 15),
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: state is GetDataLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : cubit.goals_list.isEmpty
                        ? const Center(child: Text("No goals yet. Tap + to add one!"))
                        : ListView.builder(
                            itemCount: cubit.goals_list.length,
                            itemBuilder: (context, index) {
                              final goal = cubit.goals_list[index];
                              print('Building item $index: $goal');
                              
                              return InkWell(
                                onTap: () {
                                  // Navigate to detail screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GoalDetailScreen(
                                        id: goal['id'] ?? 0,
                                        name: goal['name'] ?? 'No name',
                                        status: goal['status'] ?? 'No status',
                                      ),
                                    ),
                                  );
                                },
                                child: goalItem(
                                  goal['id'] ?? 0,
                                  goal['name'] ?? 'No name',
                                  goal['status'] ?? 'No status',
                                ),
                              );
                            },
                          ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 54, 225, 77),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    content: SizedBox(
                      height: 252,
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            child: const Center(
                              child: Text(
                                'Add New Goal',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: cubit.addTextController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Enter Goal',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            maxLines: 3,
                            controller: cubit.statusTextController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                                child: Container(
                                  width: 70,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(255, 243, 38, 2),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 247, 246, 246),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (cubit.addTextController.text.trim().isEmpty) {
                                    print('⚠️ Goal name is empty');
                                    return;
                                  }
                                  
                                  await cubit.insertData(
                                    cubit.addTextController.text.trim(),
                                    cubit.statusTextController.text.trim(),
                                  );
                                  Navigator.of(dialogContext).pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(255, 7, 243, 12),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 253, 253, 253),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 33,
              ),
            ),
          );
        },
      ),
    );
  }
}