import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/components/heat_map.dart';
import 'package:workout/data/workout_data.dart';
import 'package:workout/pages/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initalizeroWorkoutList();
  }

  // text controller
  final newWorkoutNameController = TextEditingController();

  // create a new workout
  void createNewWorkout() {
    showDialog(
      context: context,
      barrierDismissible:
          true, // Allows tapping on the background to dismiss the dialog
      builder: (context) => AlertDialog(
        title: const Text("Create new Workout"),
        content: TextField(
          controller: newWorkoutNameController,
          decoration: const InputDecoration(
            hintText: "Enter workout name",
          ),
        ),
        actions: [
          // Cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text("Cancel"),
          ),

          // Save button
          MaterialButton(
            onPressed: save,
            child: const Text("Save"),
          ),
        ],
      ),
    ).then((_) {
      // Clear the text field when the dialog is dismissed
      clear();
    });
  }

  // go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => WorkoutPage(
          workoutName: workoutName,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Start from the right
          const end = Offset.zero; // End at the current position
          const curve = Curves.easeInOut; // Smooth transition

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  // save workout
  void save() {
    String newWorkoutName = newWorkoutNameController.text;

    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    clear();
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear
  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text(
            'Workout Tracker',
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            //heat map
            MyHeatMap(datasets: value.hetMapDataSet, startDateYYYYMMDD: value.getStartDate()),

            // workout
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getWorkoutList().length,
              itemBuilder: (context, index) => ListTile(
                title: Text(value.getWorkoutList()[index].name),
                onTap: () => goToWorkoutPage(value.getWorkoutList()[index].name),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () =>
                      goToWorkoutPage(value.getWorkoutList()[index].name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
