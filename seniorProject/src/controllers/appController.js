const User = require('../models/userModel');
const makale = require('../models/makaleModel');
const bcrypt = require('bcrypt');
const Senior = require('../models/seniorModel');
const nodemailer = require('nodemailer');
require('dotenv').config();
const { Int } = require('mssql');
const { INTEGER } = require('sequelize');
const { boolean } = require('@google/maps/lib/internal/validate');


const IsDecoded = async (req, res, next) => {
    try {
        let jwtSecretKey = process.env.JWT_SECRET_KEY;
        const token = req.cookies.usertoken;
        const verified = jwt.verify(token, jwtSecretKey, async (e, decoded) => {
            if (decoded) {
                const layout = '../layouts/mainSecond_Layout'
                req.customData = {
                    message: layout,
                };
                next()
            }
            else {
                const layout = '../layouts/mainSecond_Layout'
                req.customData = {
                    message: layout,
                };
                next()
            }
        })
    }
    catch (err) {
        console.log(err)
    }
}

const getThesis = async (req, res, next) => {
    console.log("Get Thesis Function in");
    const data = {
        message: 'Merhaba, bu bir örnek veridir!'
      };
      
    
        res.json(data);
      
}
const appLogin = async (req, res, next) => {
  const { username, password } = req.body;

  try {
    const user = await User.findOne({ username });
  
    if (user) {
      // hashlenmiş şifre kontrolü
      const isMatch = await bcrypt.compare(password, user.password);
      
      if (isMatch) {
        // Kullanıcı rolüne göre veri çekme
        if (user.role === 'student') {
          // Öğrenciye ait verileri Student koleksiyonundan çek
          const studentData = await Student.findOne({ userId: user._id }); // userId, Student koleksiyonunda kullanıcıyı tanımlayan bir alan olmalıdır.
          
          if (studentData) {
            res.json({ success: true, message: "Giriş başarılı.", user: user, studentData: studentData });
          } else {
            res.json({ success: false, message: "Öğrenci verisi bulunamadı." });
          }
        } else {
          // Kullanıcı öğrenci değilse, sadece genel kullanıcı bilgilerini döndür
          res.json({ success: true, message: "Giriş başarılı.", user: user });
        }
      } else {
        res.json({ success: false, message: "Şifre hatalı." });
      }
    } else {
      res.json({ success: false, message: "Kullanıcı bulunamadı." });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Giriş sırasında hata oluştu." });
  }
};

  const getUserData = async (req, res, next) => {
    const userUniqueID = req.params.userId;
  

    const user = await User.findOne({ userUniqueID: userUniqueID });

    try {
        const articles = await makale.find({ author: userUniqueID });
        //console.log(user['notifications']);
        res.json({ success: true, message: "Makale Bulundu.", articles: articles, notifications: user['notifications'] });
    } catch (error) {
        res.json({ success: false, message: "Makale Bulunamadı." });
    }
};


const updateUser = async (req, res, next) => {
    const { userUniqueID, ...updateData } = req.body;

    try {
        // findOneAndUpdate metodunu kullanarak, userUniqueID'ye göre kullanıcıyı bul ve güncelle
        const updatedUser = await User.findOneAndUpdate({ userUniqueID: userUniqueID }, updateData, { new: false });

        if (!updatedUser) {
            return res.status(404).send('User not found');
        }

        // Güncellenmiş kullanıcıyı geri dön
        res.status(200).send(updatedUser);
    } catch (error) {
        // Hata durumunda, 500 hatası gönder
        res.status(500).send(error.message);
    }
};


const deleteUser = async (req, res, next) => {

  const { userUniqueID, ...updateData } = req.body;


  try {
    const { userUniqueID } = req.body;

    
    const deletedUser = await User.findByIdAndDelete(userUniqueID);

    if (!deletedUser) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Başarılı bir şekilde silindiğine dair bir yanıt gönder
    res.status(200).json({ message: 'User successfully deleted', deletedUser });
  } catch (error) {
    // Hata oluşursa, hata mesajı ile birlikte 500 durum kodu gönder
    res.status(500).json({ message: 'An error occurred', error: error.message });
    next(error);
  }
};


const makeRead = async (req, res, next) => {

  const { userUniqueID, ...updateData } = req.body;

  try {
    // `userUniqueID`'ye göre kullanıcıyı bul ve sadece `isRead` alanını güncelle
    const updatedUser = await User.findOneAndUpdate(
      { userUniqueID: userUniqueID },
      { $set: { isRead: isRead } }, // `$set` operatörü ile sadece belirli bir alanı güncelle
      { new: true } // Güncellenmiş belgeyi döndürmek için `new: true` seçeneğini kullan
    );

    if (!updatedUser) {
      return res.status(404).send('User not found');
    }

    // Güncellenmiş kullanıcıyı geri dön
    res.status(200).send(updatedUser);
  } catch (error) {
    // Hata durumunda, 500 hatası gönder
    res.status(500).send(error.message);
  }
};


const fetchSeniors = async (req, res, next) => {
  try {
    const userId = req.params.userId;
    const user = await User.findOne({ userUniqueID: userId });

    const seniors = await Senior.find({}, 'contactStudentId seniorName seniorPdf seniorVideo members department master grade createdAt isMasterGraded masterGrade -_id');
    
    const result = seniors.map(senior => {
      let isMasterGraded = false; // Varsayılan olarak isMasterGraded'i 0 olarak ayarla

      // Kullanıcının adı soyadı kombinasyonunu oluştur
      const userFullName = `${user.givenName} ${user.familyName}`;

      // Grade alanındaki her öğeyi kontrol et
      senior.grade.forEach(item => {
        // Eğer grade'de kullanıcının adı soyadı varsa isMasterGraded'i 1 yap
        if (item.master === userFullName) {
          isMasterGraded = true;
        }
      });

      return {
        contactStudentId: senior.contactStudentId,
        seniorName: senior.seniorName,
        seniorPdf: senior.seniorPdf,
        seniorVideo: senior.seniorVideo,
        members: senior.members,
        department: senior.department,
        master: senior.master,
        grade: senior.grade,
        createdAt: senior.createdAt,
        isMasterGraded: isMasterGraded, // Güncellenmiş isMasterGraded değerini kullan
        masterGrade: senior.masterGrade
      };
    });

    console.log('Döndürülen Senior Verileri:', result);

    res.json({ seniors: result });
  } catch (error) {
    res.status(500).json({ message: 'Sunucuda bir hata oluştu.' });
  }
};

const fetchStundets = async (req, res, next) => {
  try {
    const userId = req.params.userId;
    const user = await User.findOne({ userUniqueID: userId });

    const seniors = await Senior.find({}, 'contactStudentId seniorName seniorPdf seniorVideo members department master grade createdAt isMasterGraded masterGrade -_id');
    
    const result = seniors.map(senior => {
      let isMasterGraded = false; // Varsayılan olarak isMasterGraded'i 0 olarak ayarla

      // Kullanıcının adı soyadı kombinasyonunu oluştur
      const userFullName = `${user.givenName} ${user.familyName}`;

      // Grade alanındaki her öğeyi kontrol et
      senior.grade.forEach(item => {
        // Eğer grade'de kullanıcının adı soyadı varsa isMasterGraded'i 1 yap
        if (item.master === userFullName) {
          isMasterGraded = true;
        }
      });

      return {
        contactStudentId: senior.contactStudentId,
        seniorName: senior.seniorName,
        seniorPdf: senior.seniorPdf,
        seniorVideo: senior.seniorVideo,
        members: senior.members,
        department: senior.department,
        master: senior.master,
        grade: senior.grade,
        createdAt: senior.createdAt,
        isMasterGraded: isMasterGraded, // Güncellenmiş isMasterGraded değerini kullan
        masterGrade: senior.masterGrade
      };
    });

    console.log('Döndürülen Senior Verileri:', result);

    res.json({ seniors: result });
  } catch (error) {
    res.status(500).json({ message: 'Sunucuda bir hata oluştu.' });
  }
};


const fetchSenior = async (req, res, next) => {
  try {
    // Kullanıcı ID'si, URL parametresinden alınır
    const userId = req.params.userId;
    const user = await User.findOne({ userUniqueID: userId });
  
    // Kullanıcının senior belgesini bulur
    const senior = await Senior.findOne(
      { contactStudentId: user.userUniqueID },
      'contactStudentId seniorName seniorPdf seniorVideo members member department master grade createdAt masterGrade isMasterGraded final comment -_id'
    );

    console.log('Döndürülen Senior Verisi:', senior);
    
    
    if (!senior) {
      return res.status(404).json({ message: 'Kullanıcıya ait senior bulunamadı.' });
    }

  
    res.json({ senior });
  } catch (error) {
    
    res.status(500).json({ message: 'Sunucuda bir hata oluştu.' });
  }
};

const fetchMaster = async (req, res, next) => {

  try {
   
    const department = req.query.department;
    const users = await User.find({ department: department });
    
    const masters = users.map(user => ({
      givenName: user.givenName,
      familyName: user.familyName,
      userUniqueID: user.userUniqueID // Burada userUniqueID, modelinizdeki benzersiz kullanıcı tanımlayıcınızın alan adıdır
    }));

    res.json({ success: true, message: "Masters Received", masters: masters });
  } catch (error) {
    res.status(500).json({ success: false, message: "Server Error", error: error.message });
  }
};


const fetchStudent = async (req, res, next) => {
  //console.log("Fetching")
  try {
   
    const masterId  = req.params.userId;

    // !!!! DEPARTMANT YOK USERDA
    const Seniors = await Senior.find({ masterUniqueID:masterId });
    
    const students = users.map(user => ({
      givenName: user.givenName,
      familyName: user.familyName,
      userUniqueID: user.userUniqueID // Burada userUniqueID, modelinizdeki benzersiz kullanıcı tanımlayıcınızın alan adıdır
    }));
    console.log(students)
    res.json({ success: true, message: "Students Received", students: students });
  } catch (error) {
    res.status(500).json({ success: false, message: "Server Error", error: error.message });
  }
};

const fetchStudents = async (req, res, next) => {
  try {
    const masterId = req.params.userId;
  
    const master = await User.findOne({ userUniqueID: masterId });
 
    const fullName = master.givenName+" "+master.familyName;
    const students = await User.find({ master: fullName });
    console.log("students: "+students);
    // Öğrencilere ait Senior bilgilerini çek
    const seniorData = await Promise.all(students.map(async (student) => {
      const seniors = await Senior.find({ contactStudentId: student.userUniqueID });
      return {
        username: student.username,
        seniorName: seniors.map(senior => senior.seniorName),
        seniorFullName:student.givenName + ' ' + student.familyName,
        isSubmitted: student.isSubmitted,
        teamMember: student.teamMember,
        seniorName: student.seniorName,
       
        seniorsDetails: seniors
      };
    }));

    //console.log(seniorData);
    res.json({ success: true, message: "Students and their seniors received", students: seniorData });
  } catch (error) {
    res.status(500).json({ success: false, message: "Server Error", error: error.message });
  }
};



const committee = async (req, res, next) => {


  try {
   // Kullanıcı ID'si, URL parametresinden al
    const userId = req.params.masterId; // Kullanıcı ID'si, URL parametresinden alınır
    console.log(userId);
    const seniors = await Senior.find(
      { masterUniqueID: { $ne: userId } },
      'contactStudentId seniorName seniorPdf seniorVideo members department master grade createdAt -_id'
    );
    // Döndürülecek veriyi hazırlıyoruz
    const result = seniors.map(senior => {
      return {
        contactStudentId: senior.contactStudentId,
        seniorName: senior.seniorName,
        seniorPdf: senior.seniorPdf,
        seniorVideo: senior.seniorVideo,
        members:senior.members,
        department:senior.department,
        master:senior.master,
        grade:senior.grade,
        createdAt:senior.createdAt
      };
    });

    console.log('Döndürülen Senior Verileri:', result);

    res.json({ seniors: result });
  } catch (error) {
    res.status(500).json({ message: 'Sunucuda bir hata oluştu.' });
  }
};

const vote = async (req, res, next) => {
  try {
  
    const { grade } = req.body;
    const seniorId = grade.senior_id
   
    console.log("seniorID"+seniorId)
    const userId= req.params.userId

    const user = await User.findOne({ userUniqueID: userId });

    let userFullName = user.givenName + ' ' + user.familyName;
    //console.log(userFullName)
    // Yeni bir gradeMap nesnesi oluştur
    
    const newGradeMap = {
      master: userFullName,
      point: grade.point
    };

    const newCommentSchema = {
      master: userFullName,
      comment:grade.comment
    };

    console.log(newGradeMap)
    console.log(newCommentSchema)
    // Güncellenecek belgeyi bul ve grade dizisine yeni bir öğe ekle
    
    
    const senior = await Senior.findOneAndUpdate(
      { contactStudentId: seniorId },
      {
        $push: { 
          grade: newGradeMap, // Şema adını düzeltildi
          comment: newCommentSchema // Şema adını düzeltildi
        }
      },
      { new: true }
    );


    console.log("yeni senior: "+senior)
    const masterCount = await User.countDocuments({ role: 3, department: "Computer Engineering" });

    // Seniorun grade alanındaki kayıt sayısını al
    const seniorGradeCount = senior.grade.length;
    console.log(seniorGradeCount);

    // Tüm masterların oylaması tamamlandı mı kontrol et ve seniorun durumunu güncelle
    const isAllMasterGraded = masterCount === seniorGradeCount;
    console.log(isAllMasterGraded);
    await Senior.findOneAndUpdate(
      { contactStudentId: seniorId },
      { $set: { isAllMasterGraded: isAllMasterGraded } },
      { new: true }
    );


    if (isAllMasterGraded) {
      // Grade alanındaki tüm puanları al
      const grades = senior.grade.map(grade => grade.point);
    
      // Puanların ortalamasını hesapla
      const averageGrade = grades.reduce((total, current) => total + current, 0) / grades.length;
    
      // Ortalama puanı senior belgesine ekle
      await Senior.findOneAndUpdate(
        { contactStudentId: seniorId },
        { $set: { final: averageGrade } },
        { new: false }
      );
    }

    // Başarılı bir yanıt gönderin
    return res.status(200).json({ message: "Grade başarıyla güncellendi" });
  } catch (error) {
    // Herhangi bir hata durumunda hata mesajı gönderin
    return res.status(500).json({ error: error.message });
  }
};

const saveStudent = async (req, res, next) => {
  console.log('Saving student');
  const saltRounds = 10; // Kullanılacak tuzun (salt) miktarı
  try {
    const { senior } = req.body;
    console.log(senior);

    const username = senior.studentNumbers[0] + '@ogrenci.karabuk.edu.tr';
    const password = generateRandomPassword();
    console.log("user: " + username);
    console.log("pass: " + password);
    const parts = senior.fullNames[0].split(" "); // Boşluk karakterine göre stringi ayır

    // İsim ve soyisimi ayrı değişkenlere ata
    const firstName = parts[0];
    const lastName = parts[1];
    let teamMember = null;
    if (senior.studentNumbers.length === 2) {
      teamMember = senior.studentNumbers[1]; // Takım üyesi öğrenci numarasını al
    }
    
    // Şifreyi bcrypt ile kriptola
    const hashedPassword = await bcrypt.hash(password, saltRounds);
    console.log('Kriptolanmış şifre:', hashedPassword);

    const newUser = new User({
      username: username, // Öğrenci numarasını kullanıcı adı olarak kullanabilirsiniz
      password: hashedPassword,
      department: senior.department,
      seniorName:senior.seniorName,
      studentNumber:senior.studentNumbers[0],
      affiliation: " aff",
      master:senior.master,
      email: username,
      givenName: parts[0], // Öğrencinin adını kullanabilirsiniz
      familyName: parts[1],
      role: 2, // Varsayılan rolü belirleyebilirsiniz
      createdAt: Date.now(), 
      updatedAt: Date.now(),
      isSubmitted: false,
      teamMember: teamMember,
    });



    const savedUser = await newUser.save();

    
    // Mail gönderme işlemi
    const transporter = nodemailer.createTransport({
      service: 'gmail', // E-posta sağlayıcınıza göre ayarlayın
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS 
      }
    });
    console.log(newUser.email);

    ///*Mail İşlemleri
    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: newUser.email, // Gerçek e-posta adresi newUser.email ile değiştirilmeli
      subject: 'Welcome to Karabuk University',
      text: `Merhaba ${firstName},\n\nHesabın başarılı bir şekilde oluşturulmuştur.Uygulamaya ${username} kullanıcı ve ${password} şifresi ile giriş yapabilirsin.\n\nİyi Günler,\nKarabuk Üniversitesi`
    };

    transporter.sendMail(mailOptions, function(error, info){
      if (error) {
        console.log('Error sending email:', error);
      } else {
        console.log('Email sent: ' + info.response);
      }
    });
    //*/
    console.log('Saved user:', savedUser);
    res.status(200).json({ message: 'User saved successfully' });
  } catch (error) {
    // Herhangi bir hata durumunda hata mesajı gönderin
    console.error('Error saving user:', error);
    return res.status(500).json({ error: error.message });
  }
};



const generateRandomPassword = () => {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let password = '';

  for (let i = 0; i < 10; i++) {
    const randomIndex = Math.floor(Math.random() * characters.length);
    password += characters[randomIndex];
  }

  return password;
};

module.exports = {

    getThesis,
    appLogin,
    getUserData,
    updateUser,
    deleteUser,
    makeRead,
    fetchSeniors,
    fetchSenior,
    fetchMaster,
    fetchStudent,
    committee,
    vote,
    saveStudent,
    fetchStudents
}
