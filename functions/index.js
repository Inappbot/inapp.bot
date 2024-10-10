const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Get the Gemini, Pinecone, and OpenAI API keys.
const GEMINI_API_KEY = functions.config().gemini.apikey;
const PINECONE_API_KEY = functions.config().pinecone.apikey;
const OPENAI_API_KEY = functions.config().openai.apikey;

const verifyAuth = (req, res, next) => {
  if (!req.headers.authorization ||
      !req.headers.authorization.startsWith("Bearer ")) {
    res.status(403).send("Unauthorized");
    return;
  }

  const idToken = req.headers.authorization.split("Bearer ")[1];

  admin.auth().verifyIdToken(idToken)
      .then((decodedToken) => {
        req.user = decodedToken;
        next();
      })
      .catch((error) => {
        res.status(403).send("Unauthorized");
      });
};

// Function to get Gemini API key
exports.getGeminiApiKey = functions.https.onRequest((req, res) => {
  verifyAuth(req, res, () => {
    res.status(200).json({apiKey: GEMINI_API_KEY});
  });
});

// Function to get Pinecone and OpenAI API keys
exports.getPineconeAndOpenAiApiKeys = functions.https.onRequest((req, res) => {
  verifyAuth(req, res, () => {
    res.status(200).json({
      pineconeApiKey: PINECONE_API_KEY,
      openAiApiKey: OPENAI_API_KEY,
    });
  });
});
