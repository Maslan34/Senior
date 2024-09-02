const { boolean } = require('@google/maps/lib/internal/validate');
const mongoose = require('mongoose');
const uuidv4 = require('uuid').v4;
const Schema = mongoose.Schema;

const studentSchema = new Schema({
    userUniqueID: {
      type: String,
      default: uuidv4,
      trim: true,
    },
    username: {
      type: String,
      trim: true,
    },
    password: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
    },
    givenName: {
      type: String,
    },
    familyName: {
      type: String,
    },
    role: {
      type: Number,
      default: 2,
    },
    active: {
      type: Boolean,
      default: true,
    },
    getNotifications: {
      type: Boolean,
    },
    notifications: [{
      title: {
        type: String,
        required: true,
      },
      time: {
        type: Date,
        required: true,
      },
      text: {
        type: String,
        required: true,
      },
    }],
  }, { collection: 'students', timestamps: true });

const Student = mongoose.model('students', studentSchema);

module.exports = Student;