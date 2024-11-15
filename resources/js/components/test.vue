<template>
	test
</template>

<script lang="ts" setup>

import { onBeforeUnmount, onMounted, onUnmounted } from "vue";


onMounted(() => {
	console.log('onMounted - test.vue');
});

onUnmounted(() => {
	console.log('onUnmounted - test.vue');
});

onBeforeUnmount(() => {
	console.log('onBeforeUnmount - test.vue');
});


</script>