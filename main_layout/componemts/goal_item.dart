import 'package:flutter/material.dart';

Widget goalItem(int id, String goalName, String status) => Container(
  margin: const EdgeInsets.all(8),
  height: 80,
  width: double.infinity,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3),
      ),
    ],
    gradient: LinearGradient(
      begin: Alignment.topRight,
      colors: [
        const Color.fromARGB(183, 223, 155, 238).withOpacity(0.8),
        const Color.fromARGB(255, 7, 238, 7).withOpacity(0.3),
      ],
    ),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Text(
          '$id : $goalName',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 152, 3, 189),
          ),
        ),
      ),
      const SizedBox(height: 5),
      Text(
        status,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    ],
  ),
);