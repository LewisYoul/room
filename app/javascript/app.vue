<template>
  <div style="height: 100%;">
    <div v-if="!name" id="name-input">
      <h1>ROOM</h1>
      <input @keyup="updateName($event)" placeholder="Enter your name">
    </div>
    <div class="chat-wrapper" v-else>
      <div id="conversation" class="conversation-wrapper">
        <div v-for="message in messages" :key="message.body" :align="message.sent_by === name ? 'right' : 'left'">
          <div class="message-wrapper" align="left">
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
  data: function () {
    return {
      chatChannel: null,
      name: null,
      messages: []
    }
  },


  created() {
    const self = this;
    this.chatChannel = App.cable.subscriptions.create(
      { channel: 'ApplicationCable::ChatChannel', room: 'home' }, {
        received: function(data) { 
          self.messages.push(data)

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
  margin-top: -50px;
  margin-left: -100px;
  width: 200px;
  text-align: center;
}

.chat-wrapper {
  width: 30%;
  height: 60%;
  display: flex;
  flex-direction: column;
  margin: 10px;
}

.conversation-wrapper {
  flex: 5;
  border-radius: 16px;
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
  border-radius: 10px;
  margin-top: 10px;
  background-color: lightblue;
  font-family: 'Courier New', Courier, monospace;
}

.message-wrapper {
  display: inline-block;
  margin: 10px 10px 0px 10px;
  border-radius: 10px;
  background-color: aliceblue;
  padding: 10px;
  font-family: 'Courier New', Courier, monospace;
}
</style>
