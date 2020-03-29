<template>
  <div style="height: 100%;">
    <div v-if="!name" id="name-input">
      <h1>ROOM</h1>
      <input id="name" @keyup="updateName($event)" placeholder="Enter your name">
    </div>
    <div class="chat-wrapper" v-else>
      <div id="conversation" class="conversation-wrapper">
        <div v-for="message in messagez" :key="message.id" :align="message.sent_by === name ? 'right' : 'left'">
          <div :class="`message-wrapper--${message.sent_by === name ? 'me' : 'other'}`" align="left">
            <!-- <div><strong>{{ message.sent_by }}</strong></div> -->
            <div v-if="!(message.sent_by === name)"><strong>{{ message.sent_by }}</strong></div>
            <div style="margin-top: 5px;">{{ message.body }}</div>
          </div>
        </div>
      </div>
        <textarea class="input" @keyup="sendMessage($event)" placeholder="Type something..."></textarea>
    </div>
  </div>
</template>

<script>
export default {

  props: {
    messages: { type: Array, required: true }
  },

  data: function () {
    return {
      chatChannel: null,
      name: null,
      messagez: JSON.parse(JSON.stringify(this.messages))
    }
  },


  created() {
    const self = this;
    this.chatChannel = App.cable.subscriptions.create(
      { channel: 'ApplicationCable::ChatChannel', room: 'home' }, {
        received: function(data) { 
          self.messagez.push(data)

          setTimeout(() => {
            var objDiv = document.getElementById("conversation");
            objDiv.scrollTop = objDiv.scrollHeight;
          }, 200)
        } 
      }
    )
  },

  methods: {
    updateName(event) {
      const name = event.target.value

      if (event.keyCode == 13 && name.length > 0) {
        this.name = event.target.value
      }
    },

    sendMessage(event) {
      const message = event.target.value

      if (event.keyCode == 13 && message.length > 0) {
        if (this.name) {
          this.chatChannel.send({
            room: "home",
            sent_by: this.name,
            body: event.target.value
          })
          event.target.value = '';
        } else {
          alert("Please enter a name")
        }
      }
    }
  }
}
</script>

<style scoped>
#name-input {
  position: absolute;
  top: 50%;
  left: 50%;
  margin-top: -150px;
  margin-left: -150px;
  width: 300px;
  height: 300px;
  text-align: center;
}

#name {
  font-size: 20px;
  border: none;
  padding: 10px;
  text-align: center;
  border-bottom: 1px solid black;
}

.chat-wrapper {
  width: 25%;
  height: 60%;
  display: flex;
  flex-direction: column;
  margin: 10px;
}

.conversation-wrapper {
  flex: 5;
  background-color: antiquewhite;
  max-height: 75%;
  overflow-y: scroll;
  padding-bottom: 10px;
}

.input {
  font-size: 16px;
  padding: 6px;
  flex: 1;
  border: none;
  margin-top: 10px;
  background-color: lightblue;
}

.message-wrapper--me {
  display: inline-block;
  margin: 10px 10px 0px 10px;
  background-color: beige;
  padding: 10px;
}

.message-wrapper--other {
  display: inline-block;
  margin: 10px 10px 0px 10px;
  background-color: aliceblue;
  padding: 10px;
}
</style>
