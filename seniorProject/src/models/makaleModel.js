const { string, object } = require("@google/maps/lib/internal/validate");
const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const { v4: uuidv4 } = require('uuid');
const UserSchema = new Schema(
  {
    makaleID: {
      type: String,
      default: uuidv4()
    },
    title: {
      type: String,
    },
    subject: {
      type: String,
    },
    author: {
      type: String,
    },
    authorName:{
      type: String
    },
    status:{
      type:String
    },

    makaleIcerigi: {
      type: Object,
    },

    pdfThesis: {
      type: String,
    },
    makaleEditor: {
        type: String
    },
    editorID: {
      type: String
    },
    active: {
      type: String,
      default: "1",
    },
    seenAbleEditors: {
      type: Array,
      default: []
    },
    seenAbleRefree:[
      {
        refreeID: {
          type: String
        },
        Name_Surname: {
          type: String
        }
      }
    ],
    revisionCount:{
      type:Number
    },
    refreeNotes: [
      {
        refreeName: {
          type: String
        },
        refreeDecision: {
          type: Number
        },
        refreeNote: {
          type: String
        },
        refreePdf:{
          type:String
        }
      }
    ]
  },
  { collection: "Makale", timestamps: true }
);

const Admin = mongoose.model("Makale", UserSchema);

module.exports = Admin;
