const { boolean } = require('@google/maps/lib/internal/validate');
const mongoose = require('mongoose');
const uuidv4 = require('uuid').v4;
const Schema = mongoose.Schema;

const UserSchema = new Schema({
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
  affiliation: {
    type: String,
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
  seniorName: {
    type: String,
  },
  privacyAgreement: {
    type: String,
  },
  notifyAgreement: {
    type: String,
  },
  journalAgreement: {
    type: String,
  },
  department: {
    type: String,
    default: "",
  },
  studentNumber: {
    type: String,
    required: true,
  },
  master:{
    type: String,
    required: true,
  },
  role: {
    type: Number,
    default: 1,
  },
  active: {
    type: String,
    default: "1",
  },
  topics: {
    type: Array,
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
  teamMember:{
    type:[String],
  },
  isSubmitted:{
    type: Boolean,
    required: true,
  }
}, { collection: 'Users', timestamps: true });

const User = mongoose.model('Users', UserSchema);

module.exports = User;