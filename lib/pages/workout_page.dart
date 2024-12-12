import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/components/exercise_tile.dart';
import 'package:workout/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //check box
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExcercise(workoutName, exerciseName);
  }

  //text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  //create new exercise
  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Adjust column size to fit content
          children: [
            // Exercise name
            TextField(
              controller: exerciseNameController,
              decoration: const InputDecoration(
                hintText: 'Exercise Name',
              ),
            ),

            // Weight
            TextField(
              controller: weightController,
              keyboardType:
                  TextInputType.number, // Set keyboard for numeric input
              decoration: const InputDecoration(
                hintText: 'Weight (kg)',
              ),
            ),

            // Reps
            TextField(
              controller: repsController,
              keyboardType:
                  TextInputType.number, // Set keyboard for numeric input
              decoration: const InputDecoration(
                hintText: 'Reps',
              ),
            ),

            // Sets
            TextField(
              controller: setsController,
              keyboardType:
                  TextInputType.number, // Set keyboard for numeric input
              decoration: const InputDecoration(
                hintText: 'Sets',
              ),
            ),
          ],
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

  // save workout
  void save() {
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName, weight, reps, sets);

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
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .name,
            weight: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .weight,
            reps: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .reps,
            sets: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .sets,
            isCompleted: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .isCompleted,
            onCheckBoxChanged: (val) => onCheckBoxChanged(
              widget.workoutName,
              value.getRelevantWorkout(widget.workoutName).exercises[index].name,
            ),
          ),
        ),
      ),
    );
  }
}
