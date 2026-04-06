const { Firestore } = require("@google-cloud/firestore");

class UserStateStore {
  constructor() {
    const options = {};
    if (process.env.FIRESTORE_PROJECT_ID) {
      options.projectId = process.env.FIRESTORE_PROJECT_ID;
    }
    if (process.env.FIRESTORE_DATABASE_ID) {
      options.databaseId = process.env.FIRESTORE_DATABASE_ID;
    }
    this.client = new Firestore(options);
  }

  favoritesRef(userId) {
    return this.client.collection("users").doc(userId).collection("favorites");
  }

  readingListRef(userId) {
    return this.client.collection("users").doc(userId).collection("reading_list");
  }

  async getFavorites(userId) {
    const snapshot = await this.favoritesRef(userId).get();
    return snapshot.docs.map((doc) => Number(doc.id)).sort((a, b) => a - b);
  }

  async addFavorite(userId, bookId) {
    await this.favoritesRef(userId).doc(String(bookId)).set({ book_id: bookId, created_at: new Date().toISOString() });
  }

  async removeFavorite(userId, bookId) {
    await this.favoritesRef(userId).doc(String(bookId)).delete();
  }

  async getReadingList(userId) {
    const snapshot = await this.readingListRef(userId).get();
    return snapshot.docs.map((doc) => Number(doc.id)).sort((a, b) => a - b);
  }

  async addReadingList(userId, bookId) {
    await this.readingListRef(userId).doc(String(bookId)).set({ book_id: bookId, created_at: new Date().toISOString() });
  }

  async removeReadingList(userId, bookId) {
    await this.readingListRef(userId).doc(String(bookId)).delete();
  }
}

module.exports = { UserStateStore };
