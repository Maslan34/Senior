const { validationResult } = require('express-validator');
const Admin = require('../models/adminModel');
const bcrypt = require('bcryptjs');
const passport = require('passport');
require('../config/passportLocal')(passport);


/*
 async function asyncCall() {

    const newUser = new Admin({
        kullaniciAdi: 'omer',
        isim: 'Omer',
        sifre: await bcrypt.hash('omer123', 8),
        isAdmin: '9'
    });
    await newUser.save();
    // expected output: "resolved"
  }

  asyncCall(); 



/*
/// Generate Pass
        async function generatePass(){
          const sifre = await bcrypt.hash('cancan', 8)
          console.log(sifre);
      }
  generatePass() 
*/
/////////


// AUTH CONTROLLER
const showLoginForm = (req, res, next) => {

    try {
        res.render('admin/login', { layout: '../layouts/adminLogin_Layout', title: `test`, description: ``, keywords: `` })
    } catch (err) {
        console.log(err);
    }
};



const login = (req, res, next) => {
    const hatalar = validationResult(req);
    //console.log(hatalar);
    if (!hatalar.isEmpty()) {
        console.log(hatalar.array());
        req.flash('kullaniciAdi', req.body.kullaniciAdi);
        req.flash('validation_error', hatalar.array());
        res.redirect('/admin/login');


    } else {
        res.clearCookie('loggedUser');
        res.cookie('loggedUser', req.body.kullaniciAdi, { expires: new Date(Date.now() + 900000) });
        passport.authenticate('local', {
            successRedirect: '/admin',
            failureRedirect: '/admin/login',
            failureFlash: true
        })(req, res, next);
    }
    req.flash('kullaniciAdi', req.body.kullaniciAdi);

    //res.render('login', { layout: './layout/auth_layout' })
};

const logout = (req, res, next) => {
    req.logout();
    console.log("alskfnlka")
    req.session.destroy((error) => {
        res.clearCookie('connect.sid');
        res.clearCookie("loggedUser");
        res.clearCookie("usertoken");
        res.render('login', { layout: './lyouts/adminAuth_layout', title: 'Login', success_message: [{ msg: 'Başarıyla çıkış yapıldı' }] })
        //res.redirect('/yonetim/login');
    });
};





module.exports = {
    showLoginForm,
    login,
    logout,
}