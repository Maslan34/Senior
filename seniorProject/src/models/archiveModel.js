const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const UserSchema = new Schema({
    SayimAdi: {
        type: String,
        trim: true,
    },
    CVirgul: {
        type: String,
        default: ",",
        trim: true,
    },
    Products: {
        type: Array,
    },
    sayimUID:{
      type: String,
    },
    sayimYapilanDepo: {
        type: String
    },
    sayimYapilanOfis: {
        type: String
    },
    sayimYapilanMagaza: {
        type: String
    },
    SayimAciklama: {
        type: String,
        trim: true
    },
    RafAdi : {
        type: String
    },
    isAccepted: {
        type: Number
    },
    ArchiveUID: {
        type: String
    },
    Consolidation: {
        type: Number
    },
    Is_Rejected : {
        type: Number
    },
    formattedDate: {
        type: String
    },
    active: {
        type: String,
        default: "1"
    }

}, { collection: 'Archive', timestamps: true });

const Admin = mongoose.model('Archive', UserSchema);

module.exports = Admin;