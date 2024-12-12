import 'package:flutter/material.dart';
import 'package:workout/datetime/date_time.dart';
import 'package:workout/data/hive_database.dart';
import 'package:workout/models/exercise.dart';
import '../models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();
  
  List<Workout> workoutList = [
    //default workout data
    Workout(
      name: "Upper Body", 
      exercises: [
      Exercise(
        name: "Biceps Curl", 
        weight: "10", 
        reps: "10", 
        sets: "5"
        ),
      ],
    ),
    Workout(
      name: "Lower Body", 
      exercises: [
      Exercise(
        name: "Squats", 
        weight: "10", 
        reps: "10", 
        sets: "5"
        ),
      ],
    )
  ];

  // if there are workouts already in database, then get that workout list, else use default
  void initalizeroWorkoutList () {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    }
    else {
      db.saveToDatabase(workoutList);
    }
   
    loadHeatMap();
  }


  // get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get length of a given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  // add a workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();

    // save to database
    db.saveToDatabase(workoutList);
  }

  // add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(
        name: exerciseName, 
        weight: weight, 
        reps: reps, 
        sets: sets
      ),
    );

    notifyListeners();

    // save to database
    db.saveToDatabase(workoutList);
  }

  // check off exercise
  void checkOffExcercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
    
    // Save updated workout list to the database
    db.saveToDatabase(workoutList);

    // Reload heatmap data
    loadHeatMap();
  } 

  // return relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout = workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    Exercise relevantExercise = relevantWorkout.exercises.firstWhere((excercise) => excercise.name == exerciseName);

    return relevantExercise;
  }

  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> hetMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = 
          convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      int completionStatus = db.getCompletionStatus(yyyymmdd);

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int> {
        DateTime(year, month, day): completionStatus
      };

      hetMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}