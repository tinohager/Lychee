<template>








album header

</template>
<script setup lang="ts">
import Button from "primevue/button";
import SpeedDial from "primevue/speeddial";
import Toolbar from "primevue/toolbar";
import ContextMenu from "primevue/contextmenu";
import UploadPanel from "@/components/modals/UploadPanel.vue";
import WebauthnModal from "@/components/modals/WebauthnModal.vue";
import LoginModal from "@/components/modals/LoginModal.vue";
import ImportFromLink from "@/components/modals/ImportFromLink.vue";
import ImportFromServer from "@/components/modals/ImportFromServer.vue";
import AlbumCreateDialog from "@/components/forms/album/AlbumCreateDialog.vue";
import AlbumCreateTagDialog from "@/components/forms/album/AlbumCreateTagDialog.vue";
import { computed, ComputedRef, ref, onBeforeUnmount, onMounted, onUnmounted } from "vue";
import { useLycheeStateStore } from "@/stores/LycheeState";
import { isTouchDevice } from "@/utils/keybindings-utils";
import { storeToRefs } from "pinia";
import BackLinkButton from "./BackLinkButton.vue";
import { useContextMenuAlbumsAdd } from "@/composables/contextMenus/contextMenuAlbumsAdd";
import Divider from "primevue/divider";
import { useGalleryModals } from "@/composables/modalsTriggers/galleryModals";
import WebAuthnService from "@/services/webauthn-service";
import { useRouter } from "vue-router";
import DropBox from "../modals/DropBox.vue";
import OpenLeftMenu from "./OpenLeftMenu.vue";

const props = defineProps<{
	user: App.Http.Resources.Models.UserResource;
	title: string;
	rights: App.Http.Resources.Rights.RootAlbumRightsResource;
	config: {
		is_map_accessible: boolean;
		is_mod_frame_enabled: boolean;
		is_search_accessible: boolean;
		show_keybinding_help_button: boolean;
		back_button_enabled: boolean;
		back_button_text: string;
		back_button_url: string;
		login_button_position: string;
	};
}>();

const emits = defineEmits<{
	refresh: [];
	help: [];
}>();

onMounted(() => {
	console.log('onMounted - AlbumsHeader.vue');
});

onUnmounted(() => {
	console.log('onUnmounted - AlbumsHeader.vue');
});

onBeforeUnmount(() => {
	console.log('onBeforeUnmount - AlbumsHeader.vue');
});


const lycheeStore = useLycheeStateStore();
const { is_login_open, dropbox_api_key, is_upload_visible } = storeToRefs(lycheeStore);
const isWebAuthnOpen = ref(false);
const router = useRouter();

const {
	isCreateAlbumOpen,
	toggleCreateAlbum,
	isDeleteVisible,
	toggleDelete,
	isMergeAlbumVisible,
	toggleMergeAlbum,
	isMoveVisible,
	toggleMove,
	isRenameVisible,
	toggleRename,
	isShareAlbumVisible,
	toggleShareAlbum,
	isImportFromLinkOpen,
	toggleImportFromLink,
	isImportFromDropboxOpen,
	toggleImportFromDropbox,
	toggleUpload,
} = useGalleryModals(is_upload_visible);

const { addmenu, addMenu, isImportFromServerOpen, isCreateTagAlbumOpen } = useContextMenuAlbumsAdd(
	{
		toggleUpload: toggleUpload,
		toggleCreateAlbum: toggleCreateAlbum,
		toggleImportFromLink: toggleImportFromLink,
		toggleImportFromDropbox: toggleImportFromDropbox,
	},
	dropbox_api_key,
);

const canUpload = computed(() => props.user.id !== null);
const isLoginLeft = computed(() => props.config.login_button_position === "left");

const isWebAuthnUnavailable = computed(() => WebAuthnService.isWebAuthnUnavailable());

function openAddMenu(event: Event) {
	addmenu.value.show(event);
}

function openHelp() {
	emits("help");
}

function openSearch() {
	router.push({ name: "search" });
}



type Link = {
	type: "link";
	to: { name: string };
};
type Callback = {
	type: "fn";
	callback: () => void;
};
type Item = {
	icon: string;
	if: boolean;
};
type MenuRight = (Item & Link) | (Item & Callback);

const menu = computed(() =>
	[
		{
			to: { name: "frame" },
			type: "link",
			icon: "pi pi-desktop",
			if: props.config.is_mod_frame_enabled,
		},
		{
			to: { name: "map" },
			type: "link",
			icon: "pi pi-map",
			if: props.config.is_map_accessible,
		},
		{
			icon: "pi pi-search",
			type: "fn",
			callback: openSearch,
			if: props.config.is_search_accessible,
		},
		{
			icon: "pi pi-sign-in",
			type: "fn",
			callback: lycheeStore.toggleLogin,
			if: props.user.id === null && !isLoginLeft.value,
		},
		{
			icon: "pi pi-question-circle",
			type: "fn",
			callback: openHelp,
			if: props.user.id !== null && props.config.show_keybinding_help_button,
		},
		{
			icon: "pi pi-plus",
			type: "fn",
			callback: openAddMenu,
			if: props.rights.can_upload,
		},
		{
			icon: "pi pi-eye-slash",
			type: "fn",
			callback: () => (lycheeStore.are_nsfw_visible = false),
			if: isTouchDevice() && lycheeStore.are_nsfw_visible,
		},
		{
			icon: "pi pi-eye",
			type: "fn",
			callback: () => (lycheeStore.are_nsfw_visible = true),
			if: isTouchDevice() && !lycheeStore.are_nsfw_visible,
		},
	].filter((item) => item.if),
) as ComputedRef<MenuRight[]>;

// bubble up.
function refresh() {
	emits("refresh");
}
</script>
