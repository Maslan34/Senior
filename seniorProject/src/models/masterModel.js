const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const masterSchema = new Schema({
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
      default: 1,
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
  }, { collection: 'Master', timestamps: true });

const Master = mongoose.model('Master', masterSchema);

module.exports = Master;