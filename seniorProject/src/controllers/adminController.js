const Admin = require("../models/adminModel");
const bcrypt = require("bcryptjs");

const jwt = require("jsonwebtoken");

const User = require("../models/userModel");
const makaleModel = require("../models/makaleModel");

const { v4: uuidv4 } = require("uuid");

//GET
const showHomePage = async (req, res, next) => {
  try {
    const makaleler = await makaleModel.find({active:"1"})
    const Editors = await User.find({role: 3})
    res.render("admin/adminHomePage", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
      makaleler,
      Editors
    });
    console.log(makaleler)
  } catch (err) {
    console.log(err);
  }
};
const sifreDegistir = async (req, res, next) => {
  try {
    res.render("admin/changePassword", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const KullaniciEkle = async (req, res, next) => {
  try {
    res.render("admin/userTransactions/adduser", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const kullanicilariListele = async (req, res, next) => {
  try {
    const Users = await User.find({ active: "1" });
    res.render("admin/userTransactions/edituser", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
      Users,
    });
  } catch (err) {
    console.log(err);
  }
};

const Announcements = async (req, res, next) => {
  try {
    const Users = await User.find({ active: "1" });
    res.render("admin/announcements", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
      Users,
    });
  } catch (err) {
    console.log(err);
  }
};

const UserRoles = async (req, res, next) => {
  try {
    const Users = await User.find({ active: "1" });
    res.render("admin/userRoles", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
      Users,
    });
  } catch (err) {
    console.log(err);
  }
};

const addser = async (req, res, next) => {
  try {
    const Users = await User.find({ active: "1" });
    res.render("admin/addser", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
      Users,
    });
  } catch (err) {
    console.log(err);
  }
};

const addRoles = async (req, res, next) => {
  try {
    const Users = await User.find({ active: "1" });
    res.render("admin/addRoles", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
      Users,
    });
  } catch (err) {
    console.log(err);
  }
};
const Contact = async (req, res, next) => {
  try {
    const Users = await User.find({ active: "1" });
    res.render("admin/contact", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
      Users,
    });
  } catch (err) {
    console.log(err);
  }
};

const Statistics = async (req, res, next) => {
  try {
    const Users = await User.find({ active: "1" });
    res.render("admin/statistics", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
      Users,
    });
  } catch (err) {
    console.log(err);
  }
};

const ViewProfile = async (req, res, next) => {
  try {
    const Users = await User.find({ active: "1" });
    res.render("admin/viewProfile", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
      Users,
    });
  } catch (err) {
    console.log(err);
  }
};

const AdminHomePage = async (req, res, next) => {
  try {
    const makaleler = await makaleModel.find({ active: "1" });
    res.render("admin/adminHomePage", {
      layout: "../layouts/adminHome_Layout",
      title: `ctc Karabuk Admin`,
      description: ``,
      keywords: ``,
      makaleler,
    });
  } catch (err) {
    console.log(err);
  }
};
const adminOnayMakale = async (req, res, next) => {
  try {
    const findMakale = await makaleModel.findOne({ makaleID: req.query.q });
    const editors = findMakale.seenAbleEditors
    editors.push(req.body.editor)
    if(req.body.onaylaReddet == "Onayla"){
      var degisiklik = {
        status: "approval",
        seenAbleEditors: editors
      }
    }
    else{
      var degisiklik = {
        status: "rejected"
      }
    }
    const changes = await makaleModel.findByIdAndUpdate(findMakale._id,degisiklik)
    res.redirect('../admin')
  }
  catch (err){
    console.log(err);
  }
};
const AddUser = async (req, res, next) => {
  try {
    const FindUserCount = await User.count({ username: req.body.username });
    if (FindUserCount == 0) {
      const informations = {
        username: req.body.username,
        password: await bcrypt.hash(req.body.password, 8),
        Department: req.body.Departman,
        Permission: req.body.Permission,
        Name: req.body.name,
        Surname: req.body.surname,
        Email: req.body.email,
        PhoneNumber: req.body.phoneNumber,
        userUniqueID: uuidv4(),
      };
      const newUser = new User(informations);
      await newUser.save();
      req.flash("success_message", [{ msg: "Kullanıcı Başarı ile Eklendi." }]);
      res.redirect("/admin/kullaniciEkle");
    } else {
      req.flash("validation_error", [{ msg: "Bu kullanıcı zaten ekli." }]);
      res.redirect("/admin/kullaniciEkle");
    }
  } catch (err) {
    console.log(err);
  }
};
const RemoveUser = async (req, res, next) => {
  try {
    const FindUser = await User.findOne({ userUniqueID: req.params.id });
    await User.findByIdAndRemove(FindUser._id);
    req.flash("success_message", [{ msg: "Kullanıcı Başarı ile Silindi." }]);
    res.redirect("/admin/kullanicilariListele");
  } catch (err) {
    console.log(err);
  }
};
const EditUser = async (req, res, next) => {
  try {
    const FindUser = await User.findOne({ username: req.body.username });
    const informations = {
      username: req.body.username,
      Department: req.body.Departman,
      Permission: req.body.Permission,
      Name: req.body.name,
      Surname: req.body.surname,
      Email: req.body.email,
      PhoneNumber: req.body.phoneNumber,
    };
    await User.findByIdAndUpdate(FindUser._id, informations);
    req.flash("success_message", [{ msg: "Kullanıcı Başarı ile Düzenlendi." }]);
    res.redirect("/admin/kullanicilariListele");
  } catch (err) {
    console.log(err);
  }
};
const sifreDegistirPost = async (req, res, next) => {
  try {
    const oldPassword = req.body.oldPassword;
    const newPassword = req.body.newPassword;
    const RenewPassword = req.body.RenewPassword;
    const findUser = await Admin.findOne({ isim: req.user.isim });
    const isMatch = await bcrypt.compare(oldPassword, findUser.sifre);
    if (isMatch) {
      if (newPassword == RenewPassword) {
        await Admin.findByIdAndUpdate(findUser._id, {
          sifre: await bcrypt.hash(newPassword, 8),
        });
        req.flash("success_message", [
          { msg: "Şifre Başarı İle Değiştirildi." },
        ]);
        res.redirect("/admin/sifredegistir");
      } else {
        req.flash("validation_error", [{ msg: "Yeni Şifreler Eşleşmiyor." }]);
        res.redirect("/admin/sifredegistir");
      }
    } else {
      req.flash("validation_error", [{ msg: "Eski Şifre Eşleşmiyor." }]);
      res.redirect("/admin/sifredegistir");
    }
  } catch (err) {
    console.log(err);
  }
};

const logout = (req, res, next) => {
    req.session.destroy((error) => {
        res.clearCookie('connect.sid');
        res.redirect("/admin/login")
        //res.redirect('/yonetim/login');
    });
};
module.exports = {
  showHomePage,
  Announcements,
  UserRoles,
  addser,
  addRoles,
  Contact,
  Statistics,
  ViewProfile,
  AdminHomePage,
  sifreDegistir,
  RemoveUser,
  sifreDegistirPost,
  AddUser,
  adminOnayMakale,
  kullanicilariListele,
  KullaniciEkle,
  EditUser,
  logout,
};
