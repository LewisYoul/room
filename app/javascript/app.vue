<template>
  <div>
      <label>Name</label>
      <input @keyup="updateName($event)">
      <label>Message</label>
      <input @keyup="sendMessage($event)">
      <div v-for="message in messages" :key="message.body">
        <p><strong>{{ message.sent_by }}: </strong>{{ message.body }}</p>
      </div>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      chatChannel: null,
      userName: null,
      messages: []
    }
  },

  created() {
    console.log('fds')
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
      this.userName = event.target.value
    },

    sendMessage(event) {
      if (event.keyCode == 13) {
        if (this.userName) {
          this.chatChannel.send({
            room: "home",
            sent_by: this.userName,
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
/* p {
  font-size: 2em;
  text-align: center;
} */
</style>
