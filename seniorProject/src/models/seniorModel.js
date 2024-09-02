const { boolean } = require('@google/maps/lib/internal/validate');
const mongoose = require('mongoose');
const uuidv4 = require('uuid').v4;
const Schema = mongoose.Schema;

const gradeMapSchema = new mongoose.Schema({
  master: String, // Anahtar olarak kullanılacak alanın veri tipini belirtin
  point: Number // Değer olarak kullanılacak alanın veri tipini belirtin
}, { _id: false });

const commentSchema = new mongoose.Schema({
  master: String, // Anahtar olarak kullanılacak alanın veri tipini belirtin
  comment: String // Değer olarak kullanılacak alanın veri tipini belirtin
}, { _id: false });



const seniorSchema = new mongoose.Schema({
  contactStudentId: {
    type: String,
    default: uuidv4,
    trim: true,
    required: true
  },
  masterUniqueID: {
    type: String,
    default: uuidv4,
    trim: true,
  },
  seniorName: {
    type: String,
    required: true
  },
  seniorPdf: {
    type: String,
    required: true
  },
  seniorVideo: {
    type: String,
    required: true
  },
  members: {
    type: [String],
    required:true, // Bir dizi string olarak tanımlanır.
  },
  member: {
    type: String,
    required:false, // Bir dizi string olarak tanımlanır.
  },
  department: {
    type: String,
    required:true
  },
  master: {
    type: String,
    required:true
  },
  final:{
    type:Number,
    defaultValue:-1
  },
  isMasterGraded:{
    type:Boolean,
    defaultValue:false
  },
  grade: {
    type: [gradeMapSchema], // grade alanı bir dizi olarak tanımlanıyor
    default: [], // varsayılan olarak boş bir dizi atanıyor
  },
  comment: {
    type: [commentSchema], // grade alanı bir dizi olarak tanımlanıyor
    default: [], // varsayılan olarak boş bir dizi atanıyor
  },
},{ collection: 'Seniors', timestamps: true }); // createdAt ve updatedAt zaman damgaları otomatik olarak eklenir.

const Senior = mongoose.model('Seniors', seniorSchema);

module.exports = Senior;