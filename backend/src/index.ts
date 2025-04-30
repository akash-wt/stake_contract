import 'dotenv/config'
import express from "express"
import { HDNodeWallet, toNumber } from "ethers6";
import { mnemonicToSeedSync } from "bip39";
import { PrismaClient } from '@prisma/client';


const app = express();
const prisma = new PrismaClient();
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

if (!process.env.MNEMONIC_PHASE) {
    throw new Error("MNEMONIC_PHASE is not defined in the environment variables.");
}
const seed = mnemonicToSeedSync(process.env.MNEMONIC_PHASE);

//@ts-ignore
app.post("/signup", async (req, res) => {
    try {
        const data = req.body;

        const newUser = await prisma.user.create({
            data: {
                name: data.name,
                email: data.email,
                password: data.password
            }
        });

        console.log(newUser);

        const userId = newUser.id;
        const derivationPath = `m/44'/60'/${userId}'/0'`;

        const hdNode = HDNodeWallet.fromSeed(seed);
        const child = hdNode.derivePath(derivationPath);
        console.log(child.publicKey);

        const result = await prisma.$transaction(async (prisma) => {
            const user = await prisma.user.findUnique({
                where: { id: userId }
            });

            if (!user) {
                throw new Error("User not found");
            }


            const updatedUser = await prisma.user.update({
                where: { id: userId },
                data: {
                    privateKey: child.privateKey,
                    publicKey: child.publicKey


                }
            });

            return updatedUser;
        });

        return res.status(201).json({
            message: "User created successfully",
            publicKey: child.publicKey,
            user: result
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Something went wrong!" });
    }
});


app.get("/getDepositeAddress/:userId", async (req, res) => {

    const userId = req.params.userId;
    console.log(userId);

    await prisma.user.findUnique({
        where: { id: toNumber(userId) }
    }).then((user) => {
        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }
        return res.status(200).json({ address: user.publicKey });
    }).catch((error) => {
        console.error(error);
        return res.status(500).json({ error: "Something went wrong!" });
    })


})

app.listen(3000, () => {
    console.log("app is listing on port ", 3000);

})