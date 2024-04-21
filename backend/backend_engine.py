from flask import Flask, request, jsonify

app = Flask(__name__)

# Storage for the tweet
last_tweet = None

@app.route('/submit_tweet', methods=['POST'])
def submit_tweet():
    global last_tweet
    # Retrieve tweet from JSON payload and store it
    tweet_text = request.json.get('tweetText')
    if tweet_text and len(tweet_text) <= 280:  # Simple validation for tweet length
        last_tweet = tweet_text
        return jsonify({"status": "success", "message": "Tweet received"})
    elif not tweet_text:
        return jsonify({"status": "error", "message": "No tweet text provided"}), 400
    else:
        return jsonify({"status": "error", "message": "Tweet text too long"}), 400

@app.route('/get_tweet', methods=['GET'])
def get_tweet():
    global last_tweet
    if last_tweet:
        return jsonify({"status": "success", "tweetText": last_tweet})
    else:
        return jsonify({"status": "error", "message": "No tweet submitted yet"}), 404

if __name__ == '__main__':
    app.run(debug=True, port=5000)
