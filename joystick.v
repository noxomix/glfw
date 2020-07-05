module vglfw

// Forward declaration
fn C.glfwJoystickPresent(jid int) int

fn C.glfwJoystickIsGamepad(jid int) int

fn C.glfwGetJoystickAxes(jid int, count &int) voidptr

fn C.glfwGetJoystickButtons(jid int, count &int) byteptr

fn C.glfwGetJoystickHats(jid int, count &int) byteptr

fn C.glfwGetJoystickName(jid int) charptr

fn C.glfwGetJoystickGUID(jid int) charptr

fn C.glfwSetJoystickUserPointer(jid int, pointer voidptr)

fn C.glfwGetJoystickUserPointer(jid int) voidptr

fn C.glfwGetGamepadName(jid int) charptr

fn C.glfwGetGamepadState(jid int, state &C.GLFWgamepadstate) int

fn C.vglfwGetGamepadState(jid int, buttons byteptr, axes voidptr) int

// Wrapper for the joystick ID
pub struct Joystick {
pub:
	id int
}

// Create instance
pub fn create_joystick(id int) Joystick {
	return Joystick{
		id: id
	}
}

// Is joystick present
pub fn (j &Joystick) is_present() int {
	f := C.glfwJoystickPresent(j.id)
	check_error()
	return f
}

// Is joystick a gamepad
pub fn (j &Joystick) is_gamepad() int {
	b := C.glfwJoystickIsGamepad(j.id)
	check_error()
	return b
}

// Get joystick axes
pub fn (j &Joystick) get_axes() []f64 {
	count := 0
	data := C.glfwGetJoystickAxes(j.id, &count)
	check_error()
	//
	axes := []f64{len: count}
	C.memcpy(axes.data, data, count)
	return axes
}

// Get joystick buttons
pub fn (j &Joystick) get_buttons() []byte {
	count := 0
	data := C.glfwGetJoystickButtons(j.id, &count)
	check_error()
	//
	btns := []byte{len: count}
	C.memcpy(btns.data, voidptr(data), count)
	return btns
}

// Get joystick hats
pub fn (j &Joystick) get_hats() []byte {
	count := 0
	data := C.glfwGetJoystickHats(j.id, &count)
	check_error()
	//
	hats := []byte{len: count}
	C.memcpy(hats.data, voidptr(data), count)
	return hats
}

// Get joystick name
pub fn (j &Joystick) get_name() string {
	n := C.glfwGetJoystickName(j.id)
	check_error()
	return tos3(n)
}

// Get joystic GUID
pub fn (j &Joystick) get_uuid() string {
	guid := C.glfwGetJoystickGUID(j.id)
	check_error()
	return tos3(guid)
}

// Set joystick user pointer
pub fn (j &Joystick) set_user_pointer(pointer voidptr) {
	C.glfwSetJoystickUserPointer(j.id, pointer)
	check_error()
}

// Get joystick user pointer
pub fn (j &Joystick) get_user_pointer() voidptr {
	ptr := C.glfwGetJoystickUserPointer(j.id)
	check_error()
	return ptr
}

// Get gamepad name
pub fn (j &Joystick) get_gamepad_name() string {
	n := C.glfwGetGamepadName(j.id)
	check_error()
	return tos3(n)
}

// Get gamepad state
pub fn (j &Joystick) get_gamepad_state(buttons [15]byte, axes [6]f32) int {
	ok := C.vglfwGetGamepadState(j.id, &buttons, &axes)
	check_error()
	return ok
}
