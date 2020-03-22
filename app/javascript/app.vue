<template>
  <div style="height: 100%;">
    <div v-if="!name" id="name-input">
      <h1>ROOM</h1>
      <input @keyup="updateName($event)" placeholder="Enter your name">
    </div>
    <div class="chat-wrapper" v-else>
      <div class="conversation-wrapper">
        <div v-for="message in messages" :key="message.body">
          <p><strong>{{ message.sent_by }}: </strong>{{ message.body }}</p>
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
      if (event.keyCode == 13) {
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
  padding: 6px;
  flex: 4;
  border: 2px solid grey;
  border-radius: 10px;
}

.input {
  padding: 6px;
  flex: 1;
  border: 2px solid grey;
  border-radius: 10px;
  margin-top: 10px;
}
</style>
