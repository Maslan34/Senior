const User = require("../models/userModel");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Makale = require("../models/makaleModel");
const { v4: uuidv4 } = require("uuid");

const IsDecoded = async (req, res, next) => {
  try {
    let jwtSecretKey = process.env.JWT_SECRET_KEY;
    const token = req.cookies.usertoken;
    const verified = jwt.verify(token, jwtSecretKey, async (e, decoded) => {
      if (decoded) {
        const layout = "../layouts/mainSecond_Layout";
        req.customData = {
          message: layout,
        };
        next();
      } else {
        const layout = "../layouts/mainSecond_Layout";
        req.customData = {
          message: layout,
        };
        next();
      }
    });
  } catch (err) {
    console.log(err);
  }
};
const IsLogged = async (req, res, next) => {
  try {
    let jwtSecretKey = process.env.JWT_SECRET_KEY;
    const token = req.cookies.usertoken;
    const verified = jwt.verify(token, jwtSecretKey, async (e, decoded) => {
      if (decoded) {
        next();
      } else {
        res.redirect("/homepage");
      }
    });
  } catch (err) {
    console.log(err);
  }
};
const checkUserRole = (allowedRoles) => {
  return async (req, res, next) => {
    try {
      const FindUser = await User.findOne({
        userUniqueID: req.cookies.loggedUser,
      });

      if (FindUser && allowedRoles.includes(FindUser.role)) {
        next(); // Kullanıcı bulundu ve rolü izin verilen roller içindeyse middleware'i geç
      } else {
        res.status(403).json({ message: "Yetkiniz yok" }); // Yetki yoksa hata kodu döndür
      }
    } catch (error) {
      res.status(500).json({ message: "Sunucu hatası" }); // Hata durumunda sunucu hatası döndür
    }
  };
};

const homePage = async (req, res, next) => {
  try {
    res.render("user/userHomePage", {
      layout: req.customData.message,
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const ArchivesGet = async (req, res, next) => {
  try {
    res.render("user/archives", {
      layout: req.customData.message,
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const AnnouncementsGet = async (req, res, next) => {
  try {
    res.render("user/announcements", {
      layout: req.customData.message,
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const ContactGet = async (req, res, next) => {
  try {
    res.render("user/contact", {
      layout: req.customData.message,
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const AboutTheJournalGet = async (req, res, next) => {
  try {
    res.render("user/aboutthejournal", {
      layout: req.customData.message,
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const SubmissionGet = async (req, res, next) => {
  try {
    res.render("user/submission", {
      layout: req.customData.message,
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const RegisterGet = async (req, res, next) => {
  try {
    res.render("user/register", {
      layout: req.customData.message,
      title: `Kayıt Ol`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const loginGet = async (req, res, next) => {
  try {
    res.render("user/loginPage", {
      layout: req.customData.message,
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const editorialTeamGet = async (req, res, next) => {
  try {
    res.render("user/editorialTeam", {
      layout: req.customData.message,
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const privacyStatementGet = async (req, res, next) => {
  try {
    res.render("user/privacyStatement", {
      layout: req.customData.message,
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
    });
  } catch (err) {
    console.log(err);
  }
};
const userPanelMainPageGet = async (req, res, next) => {
  try {
    const FindUser = await User.findOne({
      userUniqueID: req.cookies.loggedUser,
    });
    res.render("user/panel/user-index", {
      layout: "../layouts/userPanelLayout",
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
      FindUser,
    });
  } catch (err) {
    console.log(err);
  }
};
const userPanelInfoPageGet = async (req, res, next) => {
  try {
    const idUser = 0;
    res.render("user/panel/user-info", {
      layout: "../layouts/userPanelLayout",
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
      idUser,
    });
  } catch (err) {
    console.log(err);
  }
};
const userPanelAddThesisPageGet = async (req, res, next) => {
  try {
    const FindUser = await User.findOne({
      userUniqueID: req.cookies.loggedUser,
    });
    const idUser = 0;
    res.render("user/panel/user-add-thesis", {
      layout: "../layouts/userPanelLayout",
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,

      FindUser,
    });
  } catch (err) {
    console.log(err);
  }
};
const makaleRevisionPageGet = async (req, res, next) => {
  try {
    const FindUser = await User.findOne({
      userUniqueID: req.cookies.loggedUser,
    });
    const findMakale = await Makale.findOne({
      makaleID: req.params.makaleID,
    });
    res.render("user/panel/articleRevisionPage", {
      layout: "../layouts/userPanelLayout",
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
      FindUser,

      findMakale,
    });
  } catch (err) {
    console.log(err);
  }
};
const UserMakaleGet = async (req, res, next) => {
  try {
    const FindUser = await User.findOne({
      userUniqueID: req.cookies.loggedUser,
    });
    const findMakaleler = await Makale.find({
      author: req.cookies.loggedUser,
    });
    
    
    res.render("user/panel/makalelerim", {
      layout: "../layouts/userPanelLayout",
      title: `ctc Karabuk`,
      description: ``,
      keywords: ``,
      findMakaleler,
      FindUser,
    });
  } catch (err) {
    console.log(err);
  }
};

const UserMakaleInceleGet = async (req, res, next) => {
  try {
    const FindUser = await User.findOne({
      userUniqueID: req.cookies.loggedUser,
    });

    // Kullanıcının sahip olduğu topics dizisini al
    const userTopics = FindUser.topics;

    // Herhangi bir userTopics öğesi ile eşleşen makaleleri getir
    const findMakaleler = await Makale.find({
      $and: [
        { status: "approval" },
        { "seenAbleRefree.refreeID": { $in: req.cookies.loggedUser } }
      ]
    });

    res.render("user/panel/makaleIncelemePage", {
      layout: "../layouts/userPanelLayout",
      title: `Makale İnceleme`,
      description: ``,
      keywords: ``,
      findMakaleler,
      FindUser,
    });
  } catch (err) {
    console.log(err);
  }
};

const UserMakaleEditorGet = async (req, res, next) => {
  try {
    const FindUser = await User.findOne({
      userUniqueID: req.cookies.loggedUser,
    });
    // Kullanıcının sahip olduğu topics dizisini al
    const userTopics = FindUser.topics;
    const Editors = await User.find({role: 2})
    const findMakaleler = await Makale.find({
      $and: [
        { status: "approval" },
        { "seenAbleEditors": { $in: req.cookies.loggedUser } },
       
      ]
    });
    
   

    res.render("user/panel/editorPage", {
      layout: "../layouts/userPanelLayout",
      title: `Editör alanı`,
      description: ``,
      keywords: ``,
      findMakaleler,
      FindUser,
      Editors
    });
  } catch (err) {
    console.log(err);
  }
};
const hakemeGonder = async (req,res,next) => {
  try{
    const FindUser = await User.findOne({
      userUniqueID: req.cookies.loggedUser,
    });
    const makale = await Makale.findOne({makaleID: req.query.id.trim()})
    const hakemler = await User.find({role: 2})
    res.render("user/panel/hakemeGonder", {
      layout: "../layouts/userPanelLayout",
      title: `Editör alanı`,
      description: ``,
      keywords: ``,
      FindUser,
      makale,
      hakemler
    });
  }
  catch (err){
    console.log(err)
  }
}
const hakemeGonderPost = async (req, res, next) => {
  try {
    const findMakale = await Makale.findOne({ makaleID: req.query.q.trim() });
    const editors = req.body.editors;
    const degisiklik = editors.map(editor => {
      const [refreeID, Name_Surname] = editor.split('_');
      return { refreeID, Name_Surname };
    });
      
    
    // Veritabanına degisiklikleri kaydetmek için güncelleme işlemi
    await Makale.findByIdAndUpdate(findMakale._id, { seenAbleRefree: degisiklik });
    
    // Başarılı bir şekilde kaydedildikten sonra yönlendirme işlemi
    res.redirect('../user/makaleEditor');
  } catch (err) {
    console.log(err);
    // Hata durumunda yönlendirme veya hata mesajı gönderme
    res.status(500).send('Bir hata oluştu.');
  }
};


const Register = async (req, res, next) => {
  try {
    const saltRounds = 10;
    const passwordToHash = req.body.password;

    const passwordHash = await bcrypt.hash(passwordToHash, saltRounds);
    const uniqueId = uuidv4();

    const informations = {
      userUniqueID: uniqueId,
      username: req.body.username,
      password: passwordHash,
      affiliation: req.body.affiliation,
      email: req.body.email,
      givenName: req.body.givenName,
      familyName: req.body.familyName,
      country: req.body.country,
      privacyAgreement: req.body.privacyAgreement,
      notifyAgreement: req.body.notifyAgreement,
      journalAgreement: req.body.journalAgreement,
      topics: req.body.topics,
      role: 1,
    };

    const newUser = new User(informations);
    await newUser.save();

    res.redirect("../login");
  } catch (err) {
    console.log("Hata:", err);
  }
};

const LoginPost = async (req, res, next) => {
  try {
    const FindUser = await User.findOne({ username: req.body.username });
    if (FindUser) {
      const isMatch = await bcrypt.compare(
        req.body.password,
        FindUser.password
      );
      if (isMatch) {
        const data = {
          time: Date(),
          password: req.body.password,
        };
        const jwtToken = jwt.sign(data, process.env.JWT_SECRET_KEY, {
          expiresIn: "3d",
        });
        const bilgiler = {
          status: true,
          jwtToken: jwtToken,
          userID: FindUser.userUniqueID,
        };
        res.clearCookie("usertoken");
        res.cookie("usertoken", jwtToken, {
          expires: new Date(Date.now() + 10 * 365 * 24 * 60 * 60),
        });
        res.clearCookie("loggedUser");
        res.cookie("loggedUser", FindUser.userUniqueID, {
          expires: new Date(Date.now() + 10 * 365 * 24 * 60 * 60),
        });
        res.redirect("/user/panel");
      } else {
        const bilgiler = {
          status: false,
          errMessage: "Şifre Hatalı Girildi.",
        };
        res.json(bilgiler);
      }
    } else {
      res.json({
        status: false,
        errMessage: "Böyle bir kullanıcı bulunamadı.",
      });
    }
  } catch (err) {
    console.log(err);
  }
};

const makaleEkle = async (req, res) => {
  try {
    const title = req.body.title;
    const subject = req.body.subject;
    const articletype = req.body.articleType;
    const textAreaThesis = req.body.textAreaThesis;
    const getPdf = req.file.filename;
    const FindUser = await User.findOne({
      userUniqueID: req.cookies.loggedUser,
    });

    const Kaydedilecek = {
      title: title,
      subject: subject,
      author: FindUser.userUniqueID,
      authorName: FindUser.givenName + " " + FindUser.familyName,
      makaleIcerigi: {
        articletype: articletype,
        textAreaThesis: textAreaThesis,
      },
      editorID: "",
      pdfThesis: getPdf,
      status: "pending",
      revisionCount: 0,
    };

    const newUser = new Makale(Kaydedilecek);
    await newUser.save();
    res.redirect("/user/user-add-thesis");
  } catch (err) {
    console.log(err);
  }
};
const makaleRevisionPost = async (req, res) => {
  try {
  
    const makaleID = req.params.makaleID; // Güncellenecek makalenin ID'si URL'den alınır
    console.log(makaleID)
    const { title, subject, author, articleType, textAreaThesis } = req.body; // Güncellenecek veriler alınır
    const existingMakale = await Makale.findOne({
      makaleID: req.params.makaleID,
    });
    // revisionCount kontrolü
    if (existingMakale.revisionCount > 3) {
      return res.status(400).send("Makaleyi güncellemek için izin verilmiyor, çünkü 3 defadan fazla revizyon yapamazsınız!.");
    }
    const updatedMakale = {
      title: title,
      subject: subject,
      author: author,
      makaleIcerigi: {
        articletype: articleType,
        textAreaThesis: textAreaThesis,
      },
      revisionCount : existingMakale.revisionCount +=1,
      status:"pending",
      refreeNotes:[],
      editorID:""
    };

    // Güncellenmiş makale verileri ile mevcut makale güncellenir
    await Makale.findByIdAndUpdate(existingMakale._id, updatedMakale);

    res.redirect("/user/makaleler");
  } catch (err) {
    console.log(err);
    res.status(500).send("Makale güncellenirken bir hata oluştu.");
  }
};

const refreeNotesPost = async (req, res) => {
  const { makaleID, refreeDecision, refreeNote } = req.body;
  const refreePdf = req.file; // Dosya bilgisi req.file üzerinden alınıyor
  console.log(req.body)
  console.log(req.file)
  try {
    const makale = await Makale.findOne({ makaleID: makaleID.trim() });
    if (!makale) {
      return res.status(404).json({ message: 'Belge bulunamadı!' });
    }

    const FindUser = await User.findOne({
      userUniqueID: req.cookies.loggedUser,
    });

    // Kullanıcının not ekleyip eklemediğini ve kararını kontrol et
    const existingNoteIndex = makale.refreeNotes.findIndex(
      (note) => note.refreeName === FindUser.username
    );

    if (existingNoteIndex !== -1) {
      // Kullanıcı zaten bir not eklemiş, bu nedenle kararını ve notunu değiştir
      makale.refreeNotes[existingNoteIndex].refreeDecision = refreeDecision;
      makale.refreeNotes[existingNoteIndex].refreeNote = refreeNote;
      if (refreePdf) {
        makale.refreeNotes[existingNoteIndex].refreePdf = refreePdf.filename;
      }
    } else {
      // Kullanıcı daha önce not eklememiş, yeni bir not ekle
      const newNote = {
        refreeName: FindUser.username,
        refreeDecision: Number(refreeDecision),
        refreeNote: refreeNote,
      };
      if (refreePdf) {
        newNote.refreePdf = refreePdf.filename;
      }
      makale.refreeNotes.push(newNote);
    }

    // Güncellenmiş belgeyi kaydet
    const updatedMakale = await makale.save();

    // Başarılı yanıtı gönder
    res.status(200).json({ message: 'Belge güncellendi', updatedMakale });
  } catch (error) {
    // Hata durumunda yanıtı gönder
    res.status(500).json({ message: 'Bir hata oluştu', error: error.message });
  }
};

const editorDecisionPost = async (req, res) => {
  const { makaleID, editorDecision } = req.body;
  try {e
    const makale = await Makale.findOn({ makaleID: makaleID.trim() });
    if (!makale) {
      return res.status(404).json({ message: 'Belge bulunamadı!' });
    }

    // Editör kararına göre durumu güncelle
    if (editorDecision === '1') {
      makale.status = 'success';
    } else if (editorDecision === '2') {
      makale.status = 'rejected';
    }

    // Güncellenmiş belgeyi kaydet
    const updatedMakale = await makale.save();

    // Başarılı yanıtı gönder
    res.status(200).json({ message: 'Belge güncellendi', updatedMakale });
  } catch (error) {
    // Hata durumunda yanıtı gönder
    res.status(500).json({ message: 'Bir hata oluştu', error: error.message });
  }
};





const logout = (req, res, next) => {
  res.clearCookie("loggedUser");
  res.clearCookie("usertoken");
  res.redirect("/login");
};
module.exports = {
  homePage,
  AnnouncementsGet,
  AboutTheJournalGet,
  IsDecoded,
  IsLogged,
  checkUserRole,
  UserMakaleGet,
  userPanelMainPageGet,
  SubmissionGet,
  privacyStatementGet,
  userPanelInfoPageGet,
  userPanelAddThesisPageGet,
  makaleRevisionPageGet,
  ContactGet,
  hakemeGonderPost,
  RegisterGet,
  editorialTeamGet,
  ArchivesGet,
  Register,
  loginGet,
  LoginPost,
  hakemeGonder,
  makaleRevisionPost,
  logout,
  makaleEkle,
  refreeNotesPost,
  editorDecisionPost,
  UserMakaleInceleGet,
  UserMakaleEditorGet,
};
