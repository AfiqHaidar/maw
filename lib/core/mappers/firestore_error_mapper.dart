import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreErrorMapper {
  static String map(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return "You don't have permission to perform this action.";
      case 'unavailable':
        return "Firestore is temporarily unavailable. Please try again later.";
      case 'aborted':
        return "The operation was aborted due to a conflict or other reason.";
      case 'deadline-exceeded':
        return "The operation took too long to complete.";
      case 'not-found':
        return "The requested document was not found.";
      case 'already-exists':
        return "The document already exists.";
      case 'resource-exhausted':
        return "Quota exceeded or out of resources.";
      case 'cancelled':
        return "The operation was cancelled.";
      case 'data-loss':
        return "Unrecoverable data loss or corruption.";
      default:
        return "An unexpected Firestore error occurred.";
    }
  }
}
