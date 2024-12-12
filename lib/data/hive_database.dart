import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';
import 'package:workout/datetime/date_time.dart';
import 'package:workout/models/exercise.dart';
import 'package:workout/models/workout.dart';

class HiveDatabase {
  // reference our hive box
  final _myBox = Hive.box("workout_database1");

  //check if there is already data stored, if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("Previous data does NOT exist");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("Previous data does exist");
      return true;
    }
  }

  // return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  // write data
  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    // Count completed exercises
    int completedCount = workouts.fold(0, (total, workout) {
      return total + workout.exercises.where((e) => e.isCompleted).length;
    });

    _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", completedCount);

    // Save workouts and exercises to the database
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  // read data, and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    //create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exercisesInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }

      Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);

      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  // check if any exercise have been done
  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }

    return false;
  }

  // return completion status of agiven date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;

    return completionStatus;
  }
}

//converts workouts objects into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    //hj
  ];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }

  return workoutList;
}

//converts the exercise in a workout object into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [
    //hgh
  ];

  //go through each workout
  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [
      //h
    ];

    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [
        //hf
      ];

      individualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }

    exerciseList.add(individualWorkout);
  }

  return exerciseList;
}
