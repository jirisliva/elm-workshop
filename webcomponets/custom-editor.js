class CustomEditor extends HTMLElement {

    constructor() {
        const self = super();
        this._editorValue = "";

        const shadow = this.attachShadow({ mode: 'open' })
        const wrapper = this.addWrapper(shadow)
        const input = this.addInput(wrapper)

        const _this = this
        input.addEventListener("input", function () {
            _this.dispatchEvent(new CustomEvent("editorChanged", { detail: input.value }));
        })

        return self
    }

    get editorValue() {
        return this._editorValue
    }

    set editorValue(value) {
        if (this._editorValue === value) {
            return
        }
        this._editorValue = value
        this.updateUI(this);
    }

    addWrapper(shadow) {
        const wrapper = document.createElement("div")
        wrapper.style.padding = "5px"
        wrapper.style.background = "lightblue"
        wrapper.style.width = "320px"
        shadow.appendChild(wrapper)
        return wrapper
    }

    addInput(wrapper) {
        const input = document.createElement("input")
        input.style.margin = "5px";
        input.style.width = "90%";
        input.style.fontSize = "24px";
        input.setAttribute("id", "customEditorInput");
        wrapper.appendChild(input)
        return input
    }

    updateUI(element) {
        this.shadowRoot.querySelector("#customEditorInput").value = element._editorValue
    }

    connectedCallback() {
    }

}

customElements.define('custom-editor', CustomEditor)
