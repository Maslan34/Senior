const multer = require('multer');
const User = require('../models/userModel');
const Senior = require('../models/seniorModel');
const path = require('path');

const router = require('express').Router();
const appController = require('../controllers/appController');



const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(__dirname, '../../public/uploads/files'))
  },
  filename: function (req, file, cb) {
    cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname))
  }
})


const upload = multer({ storage: storage });

router.get('/',appController.getThesis);
router.post('/loginApp',appController.appLogin);
router.get('/fetchSeniors/:userId',appController.fetchSeniors);
router.get('/fetchSenior/:userId',appController.fetchSenior);
router.get('/user/:userId',appController.getUserData);
router.put('/updateUser',appController.updateUser);
router.get('/deleteUser',appController.deleteUser);
router.put('/makeRead',appController.makeRead);
router.get('/masters',appController.fetchMaster);
router.get('/students',appController.fetchStudent);
router.get('/committee/:masterId',appController.committee);
router.post('/vote/:userId',appController.vote);
router.post('/saveStudent/',appController.saveStudent);
router.get('/fetchStudents/:userId',appController.fetchStudents);



router.post('/senior', upload.fields([{ name: 'video', maxCount: 1 }, { name: 'pdf', maxCount: 1 }]), async (req, res) => {
  console.log("here")
  try {
    const {
      name,
      userUniqueID,
      seniorName,
      studentNumber,
      department,
      teamMemberStudentNumber,
      master,
      masterUniqueID,
      member,
    } = req.body;
   
  
    const videoPath = req.files['video'] && req.files['video'][0]
      ? req.files['video'][0].path.substring(req.files['video'][0].path.indexOf('uploads')).replace(/\\/g, '/')
      : '';
    const pdfPath = req.files['pdf'] && req.files['pdf'][0]
      ? req.files['pdf'][0].path.substring(req.files['pdf'][0].path.indexOf('uploads')).replace(/\\/g, '/')
      : '';

   
    await User.findOneAndUpdate(
      { userUniqueID: userUniqueID },
      {
        $set: {
          // 'User' modeline ait güncellenmesi gereken alanlar
          isSubmitted: true,
          // Diğer alanlar
        }
      },
      { new: true, upsert: true }
    );
    console.log(userUniqueID);
     // Yeni bir Senior nesnesi oluştur
     const newSenior = new Senior({
      masterUniqueID:masterUniqueID,
      name:name,
      contactStudentId: userUniqueID, // Bu alanı doğru şekilde doldurun
      seniorName: seniorName,
      seniorPdf: pdfPath,
      seniorVideo: videoPath,
      members: [studentNumber,teamMemberStudentNumber],
      member:member, // Bu örnekte userId kullanılıyor, gereksinimlerinize göre değiştirebilirsiniz.
      department: department,
      master: master,
      });

 
    await newSenior.save();

    res.send('Dosyalar ve proje bilgileri başarıyla yüklendi ve kullanıcı bilgileri güncellendi');
  } catch (err) {
    console.error(err);
    res.status(500).send('Sunucu hatası');
  }
});



module.exports = router;

