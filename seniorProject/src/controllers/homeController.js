const User = require('../models/userModel');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const dayjs = require('dayjs');
const { v4: uuidv4 } = require('uuid');
require('dayjs/locale/tr');
require('dayjs/plugin/timezone');
const utc = require('dayjs/plugin/utc');
const AuthorizationCheck = async (req,res,next) => {
    try{
        if(req.headers.authorization == process.env.SESSION_SECRET){
            next();
        }
        else{
            const bilgiler = {
                status: "Authorization Failed"
            }
            res.json(bilgiler)
        }
    }
    catch{
        const bilgiler = {
            status: "Authorization Failed"
        }
        res.json(bilgiler)
    }
};

const LoginPost = async (req,res,next) => {
    try{
        const FindUser = await User.findOne({username: req.body.Username})
        if(FindUser){
            if(FindUser.Permission == 2){
                const isMatch = await bcrypt.compare(req.body.Password, FindUser.password);
                if(isMatch){
                    const data = {
                        time: Date(),
                        password: req.body.Password,
                        }
                    const jwtToken = jwt.sign(data, process.env.JWT_SECRET_KEY, { expiresIn: '3d' });
                    const bilgiler = {
                        status: true,
                        jwtToken: jwtToken,
                        userID: FindUser.userUniqueID,
                    }
                    res.json(bilgiler)
                }
                else{
                    const bilgiler = {
                        status: false,
                        errMessage: "Şifre Hatalı Girildi."
                    }
                    res.json(bilgiler)
                }
            }
            else{
                res.json({status:false,errMessage: "Yetki Yetersiz."})
            }
        }
        else{
            res.json({status:false,errMessage: "Böyle bir kullanıcı bulunamadı."})
        }
    }
    catch (err){
        console.log(err)
    }
}
const getProduct = async (req,res,next) => {
    try{
        const FindProduct = await Urun.findOne({Barkod: (req.body.Barcode).toString()}) 
        const FindUser = await User.findOne({userUniqueID: req.body.userID})
        var Envanter = 0
        if(FindProduct.Inventory){
            for(let i = 0; i<FindProduct.Inventory.length;i++){
                if(FindProduct.Inventory[i].erpMagaza == FindUser.erpMagaza){
                    Envanter = Envanter + Number(FindProduct.Inventory[i].Envanter)
                }
            }
        }
        else{
            var Envanter = 0
        }
        if(FindProduct){

            res.json({status:true,Product: {FindProduct,User:FindUser,Envanter:Envanter}})

        }
        else{
            res.json({status:false,errMessage:"Urun Bulunamadı."})
        }
    }
    catch (err){
        res.json({status:false,errMessage:"Urun Bulunamadı."})
        console.log(err)
    }
}
const getSayimList = async (req,res,next) => {
    try{
        const FindProduct = await Sayim.find({$and: [{active: "1"},{Consolidation: 0}]}) 
        if(FindProduct){

            res.json({status:true,Sayim: FindProduct})

        }
        else{
            res.json({status:false,errMessage:"Urun Bulunamadı."})
        }
    }
    catch (err){
        console.log(err)
    }
}
const postSayim = async (req,res,next)  => {
    try{       
        if(req.body.Products){
            dayjs.extend(utc);
            dayjs.extend(require('dayjs/plugin/timezone'));
            const now = dayjs().tz('Europe/Istanbul');
            const formattedDate = now.format('YYYY-MM-DD');
            const findUser = await User.findOne({userUniqueID: req.body.userID})
            const Products = req.body.Products
            const SayimAdi = req.body.SayimAdi
            const SayimAciklama = req.body.SayimAciklamasi
            const RafAdi = req.body.RafAdi
            const SayimID = uuidv4()
            const informations = {
                SayimAdi: SayimAdi,
                Products: Products,
                SayimAciklama: SayimAciklama,
                sayimYapilanDepo: findUser.erpDepo,
                sayimYapilanOfis: findUser.erpOfis,
                sayimYapilanMagaza: findUser.erpMagaza,
                RafAdi: RafAdi,
                Consolidation: 0,
                isAccepted: 0,
                sayimUID: SayimID,
                SayimTarihi: formattedDate
            }
            const newUser = new Sayim(
                informations
            )
            await newUser.save();
                
            res.json({status:true})
        }
        else{
            res.json({status:false,errMessage:"Eksik Yada Hatalı Parametre Gönderildi."})
        }

    }
    catch (err){
        console.log(err)
    }
}
const test = async (req,res,next) => {
    try{
        console.log(req.body)
        res.json(req.body)
    }
    catch (err){
        console.log(err)
    }
}
module.exports = {
    LoginPost,
    AuthorizationCheck,
    postSayim,
    getSayimList,
    getProduct,
    test
}
